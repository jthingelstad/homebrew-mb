"""Manual, read-only-token bottle verification on disposable GitHub-hosted runners.

Never run this driver on a maintainer's computer. Formula trust is restricted to
one name, two reviewed recipes, and an isolated runner configuration directory.
No release uploads, git pushes, credential reads, or Micro.blog calls occur here.
"""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
TARGET = "jthingelstad/mb/mb"
TAP = "jthingelstad/mb"
REPOSITORY = "jthingelstad/homebrew-mb"
BREW = "/opt/homebrew/bin/brew"
ARTIFACTS = ROOT / "artifacts"


def digest(path: Path) -> str:
    with path.open("rb") as handle:
        return hashlib.file_digest(handle, "sha256").hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


def read_json(path: Path):
    return json.loads(path.read_text())


def write_json(path: Path, value) -> None:
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def validate_inputs() -> dict:
    inputs = read_json(ROOT / "ci/release-inputs.json")
    expected = os.environ.get("EXPECTED_FORMULA_SHA256", "")
    require(
        bool(re.fullmatch(r"[0-9a-f]{64}", expected)),
        "Reviewed formula SHA256 is required",
    )
    require(
        expected == inputs["stable"]["formula_sha256"],
        "Dispatch hash differs from the input manifest",
    )
    for kind, file in [("stable", "Formula/mb.rb"), ("rc4", "ci/mb-rc4.rb")]:
        require(
            digest(ROOT / file) == inputs[kind]["formula_sha256"],
            f"{kind} recipe changed",
        )
    return inputs


class Runner:
    def __init__(self, mode: str, inputs: dict):
        require(mode in {"build", "pour"}, "Expected build or pour")
        require(
            os.environ.get("GITHUB_ACTIONS") == "true",
            "Only GitHub-hosted runner execution is allowed",
        )
        require(
            os.environ.get("RUNNER_ENVIRONMENT") == "github-hosted",
            "Self-hosted runners are excluded",
        )
        require(
            os.environ.get("GITHUB_REPOSITORY") == REPOSITORY, "Unexpected repository"
        )
        require(
            os.environ.get("GITHUB_REF") == "refs/heads/main",
            "Only the reviewed main branch may dispatch",
        )
        require(platform.machine() == "arm64", "Apple Silicon runner required")
        require(platform.mac_ver()[0].split(".")[0] == "26", "macOS 26 runner required")
        require(
            bool(re.fullmatch(r"[0-9a-f]{40}", os.environ.get("GITHUB_SHA", ""))),
            "Invalid workflow commit",
        )
        self.mode = mode
        self.inputs = inputs
        self.work = Path(os.environ["RUNNER_TEMP"]) / f"mb-{mode}"
        require(not self.work.exists(), "The job work directory must be fresh")
        self.work.mkdir()
        self.env = os.environ.copy()
        # These values are not needed, are never printed, and do not reach hooks.
        for key in [
            "MB_TOKEN",
            "MB_BLOG",
            "MB_FORMAT",
            "PYTHONPATH",
            "PYTHONHOME",
            "GH_TOKEN",
            "GITHUB_TOKEN",
        ]:
            self.env.pop(key, None)
        for key, relative in {
            "HOME": "home",
            "XDG_CONFIG_HOME": "home/.config",
            "HOMEBREW_USER_CONFIG_HOME": "home/.config/homebrew",
            "HOMEBREW_CACHE": "cache",
            "HOMEBREW_LOGS": "logs",
            "HOMEBREW_TEMP": "tmp",
            "CARGO_HOME": "cargo-home",
            "RUSTUP_HOME": "rustup-home",
            "PIP_CACHE_DIR": "pip-cache",
        }.items():
            path = self.work / relative
            path.mkdir(parents=True, exist_ok=True)
            self.env[key] = str(path)
        self.env.update(
            {
                "HOMEBREW_NO_AUTO_UPDATE": "1",
                "HOMEBREW_NO_INSTALL_FROM_API": "1",
                "HOMEBREW_NO_ANALYTICS": "1",
                "HOMEBREW_NO_INSTALL_CLEANUP": "1",
                "HOMEBREW_NO_ASK": "1",
                "HOMEBREW_NO_INSTALL_UPGRADE": "1",
                "HOMEBREW_NO_ENV_HINTS": "1",
            }
        )
        self.evidence = {
            "mode": mode,
            "workflow_commit": os.environ["GITHUB_SHA"],
            "run_id": os.environ["GITHUB_RUN_ID"],
            "source_commit": inputs["stable"]["commit"],
            "formula_sha256": inputs["stable"]["formula_sha256"],
            "macos": platform.mac_ver()[0],
            "architecture": platform.machine(),
            "checks": [],
        }
        self.tap_path: Path | None = None

    def run(self, *args: str, cwd: Path | None = None, capture: bool = False) -> str:
        print("+ " + " ".join(str(a) for a in args), flush=True)
        result = subprocess.run(
            args,
            cwd=cwd or ROOT,
            env=self.env,
            text=True,
            stdout=subprocess.PIPE if capture else None,
            check=True,
        )
        return result.stdout.strip() if capture else ""

    def brew(self, *args: str, capture: bool = False) -> str:
        return self.run(BREW, *args, capture=capture)

    def prepare(self) -> None:
        require(
            self.brew("--prefix", capture=True) == "/opt/homebrew",
            "Default Apple Silicon prefix required",
        )
        brew_repo = Path(self.brew("--repository", capture=True))
        commit = self.inputs["homebrew_commit"]
        self.run("git", "-C", str(brew_repo), "fetch", "--depth=1", "origin", commit)
        self.run("git", "-C", str(brew_repo), "checkout", "--detach", commit)
        require(
            self.run("git", "-C", str(brew_repo), "rev-parse", "HEAD", capture=True)
            == commit,
            "Homebrew framework pin failed",
        )
        self.evidence["homebrew_commit"] = commit
        self.evidence["brew_config"] = self.brew("config", capture=True)
        baseline = json.loads(self.brew("trust", "--json=v1", capture=True))
        require(
            all(not entries for entries in baseline.values()),
            "Isolated trust scope is not empty",
        )
        expected = read_json(ROOT / "ci/native-inputs.json")
        core_commits = {entry["tap_git_head"] for entry in expected}
        require(
            len(core_commits) == 1,
            "Native inputs require one frozen official core commit",
        )
        core_commit = core_commits.pop()
        require(
            bool(re.fullmatch(r"[0-9a-f]{40}", core_commit)),
            "Invalid official core commit",
        )
        # The public API can rebuild a bottle without changing its source version.
        # Consume the frozen official formula tree, rather than moving API data.
        self.brew("tap", "--force", "homebrew/core")
        core_path = Path(self.brew("--repository", "homebrew/core", capture=True))
        self.run(
            "git", "-C", str(core_path), "fetch", "--depth=1", "origin", core_commit
        )
        self.evidence["runner_core_changes"] = self.run(
            "git", "-C", str(core_path), "diff", "--stat", capture=True
        )
        # Hosted images can patch core formula files during image preparation.
        # This disposable runner must consume the exact frozen official tree.
        self.run(
            "git", "-C", str(core_path), "checkout", "--force", "--detach", core_commit
        )
        require(
            self.run("git", "-C", str(core_path), "rev-parse", "HEAD", capture=True)
            == core_commit,
            "Official core formula tree pin failed",
        )
        for entry in expected:
            sources = list((core_path / "Formula").glob("*/" + entry["name"] + ".rb"))
            require(
                len(sources) == 1,
                f"Expected one frozen native formula: {entry['name']}",
            )
            require(
                digest(sources[0]) == entry["formula_checksum"]["sha256"],
                f"Frozen native formula differs: {entry['name']}",
            )
        self.evidence["homebrew_core_commit"] = core_commit
        self.brew("tap", TAP)
        self.tap_path = Path(self.brew("--repository", TAP, capture=True))
        self.run(
            "git",
            "-C",
            str(self.tap_path),
            "fetch",
            "--depth=1",
            "origin",
            os.environ["GITHUB_SHA"],
        )
        self.run(
            "git",
            "-C",
            str(self.tap_path),
            "checkout",
            "--detach",
            os.environ["GITHUB_SHA"],
        )
        require(
            digest(self.tap_path / "Formula/mb.rb")
            == self.inputs["stable"]["formula_sha256"],
            "Tapped recipe differs from the reviewed checkout",
        )
        names = [entry["name"] for entry in expected]
        actual = json.loads(self.brew("info", "--json=v2", *names, capture=True))[
            "formulae"
        ]
        indexed = {entry["name"]: entry for entry in actual}
        for entry in expected:
            observed = indexed[entry["name"]]
            require(
                observed["versions"]["stable"] == entry["version"]
                and observed["revision"] == entry["revision"],
                f"Native version drift: {entry['name']}",
            )
            require(
                observed["urls"]["stable"]["checksum"] == entry["source"]["checksum"],
                f"Native source drift: {entry['name']}",
            )
            require(
                observed["bottle"]["stable"]["files"]["arm64_tahoe"]["sha256"]
                == entry["bottles"]["arm64_tahoe"]["sha256"],
                f"Native bottle drift: {entry['name']}",
            )
        # All native inputs must have published core bottles; never bootstrap Rust/CMake.
        self.brew("install", "--force-bottle", *names)
        actual = json.loads(self.brew("info", "--json=v2", *names, capture=True))[
            "formulae"
        ]
        for entry in expected:
            observed = next(f for f in actual if f["name"] == entry["name"])
            version = entry["version"] + (
                f"_{entry['revision']}" if entry["revision"] else ""
            )
            require(
                any(i["version"] == version for i in observed["installed"]),
                f"Native installed version differs: {entry['name']}",
            )
            require(
                Path(f"/opt/homebrew/opt/{entry['name']}").resolve().name == version,
                f"Native opt link differs: {entry['name']}",
            )
        self.evidence["native_inputs"] = actual
        self.evidence["installed_native_graph"] = self.brew(
            "list", "--versions", capture=True
        )
        self.evidence["clang"] = self.run("/usr/bin/clang", "--version", capture=True)
        self.evidence["sdk"] = self.run(
            "/usr/bin/xcrun", "--show-sdk-version", capture=True
        )

    def recipe(self, kind: str) -> None:
        require(self.tap_path is not None, "Tap has not been prepared")
        path = ROOT / ("Formula/mb.rb" if kind == "stable" else "ci/mb-rc4.rb")
        require(
            digest(path) == self.inputs[kind]["formula_sha256"],
            "Recipe hash changed before execution",
        )
        shutil.copyfile(path, self.tap_path / "Formula/mb.rb")

    def installed(self, version: str, poured: bool) -> Path:
        keg = Path(self.brew("--prefix", TARGET, capture=True)).resolve()
        tab = read_json(keg / "INSTALL_RECEIPT.json")
        require(keg.name == version, "Incorrect installed package version")
        require(
            tab.get("poured_from_bottle", False) is poured,
            "Incorrect source/bottle installation path",
        )
        if not poured:
            require(
                tab.get("built_as_bottle") is True,
                "Source upgrade did not retain bottle-build mode",
            )
        python = keg / "libexec/bin/python"
        # Keep the venv path; resolving this symlink would bypass installed modules.
        observed = json.loads(
            self.run(
                str(python),
                "-c",
                "import importlib.metadata as m,json; print(json.dumps({d.metadata['Name'].lower().replace('_','-'):d.version for d in m.distributions()}))",
                capture=True,
            )
        )
        expected = dict(read_json(ROOT / "ci/runtime-versions.json"))
        expected["mb"] = version
        require(
            all(observed.get(name) == value for name, value in expected.items()),
            "Installed runtime version drift",
        )
        require(
            set(observed) - set(expected) <= {"pip", "setuptools", "wheel"},
            "Unexpected runtime dependencies",
        )
        sources = read_json(ROOT / "ci/installed-sources.json")
        script = """import hashlib,json,mb,pathlib,sys
base=pathlib.Path(mb.__file__).parent
for rel,expected in json.loads(sys.argv[1]).items():
    assert hashlib.sha256((base/rel).read_bytes()).hexdigest()==expected, rel
print(len(json.loads(sys.argv[1])))
"""
        require(
            self.run(str(python), "-c", script, json.dumps(sources), capture=True)
            == str(len(sources)),
            "Installed MB source verification failed",
        )
        self.brew("test", TARGET)
        self.brew("linkage", "--test", TARGET)
        self.evidence["checks"].append(
            {
                "version": version,
                "poured": poured,
                "runtime_versions": observed,
                "source_files_verified": len(sources),
                "tab": tab,
            }
        )
        return python

    def build(self) -> None:
        self.recipe("rc4")
        self.brew("install", "--build-bottle", TARGET)
        python = self.installed(self.inputs["rc4"]["version"], poured=False)
        state = self.work / "synthetic-user-state"
        self.run(str(python), str(ROOT / "ci/synthetic-state.py"), str(state))
        before = {p.name: digest(p) for p in state.iterdir() if p.is_file()}
        self.recipe("stable")
        # Homebrew upgrade inherits built_bottle from the predecessor's receipt.
        self.brew("upgrade", "--build-from-source", TARGET)
        python = self.installed(self.inputs["stable"]["version"], poured=False)
        self.run(str(python), str(ROOT / "ci/synthetic-state.py"), str(state))
        require(
            before == {p.name: digest(p) for p in state.iterdir() if p.is_file()},
            "Upgrade changed external state",
        )
        self.evidence["synthetic_state_unchanged"] = True
        self.evidence["checks"].append("actual RC4 to stable source upgrade")
        ARTIFACTS.mkdir()
        self.run(
            BREW,
            "bottle",
            "--json",
            "--root-url",
            "https://github.com/jthingelstad/homebrew-mb/releases/download/mb-v2.0.0",
            TARGET,
            cwd=ARTIFACTS,
        )
        files = list(ARTIFACTS.glob("*.bottle.json"))
        require(len(files) == 1, "Expected one bottle metadata file")
        metadata = read_json(files[0])
        require(
            list(metadata) == [TARGET], "Bottle metadata names an unexpected formula"
        )
        entry = metadata[TARGET]
        require(entry["formula"]["pkg_version"] == "2.0.0", "Incorrect bottled version")
        tags = entry["bottle"]["tags"]
        require(
            list(tags) == ["arm64_tahoe"],
            "Bottle must carry the actual macOS 26 ARM64 tag",
        )
        tag = tags["arm64_tahoe"]
        bottle = ARTIFACTS / tag["local_filename"]
        require(
            bottle.is_file() and digest(bottle) == tag["sha256"],
            "Bottle hash verification failed",
        )
        self.evidence["bottle"] = {
            "filename": bottle.name,
            "sha256": digest(bottle),
            "tag": "arm64_tahoe",
            "cellar": entry["bottle"]["cellar"],
            "bytes": bottle.stat().st_size,
        }
        shutil.copyfile(ROOT / "Formula/mb.rb", ARTIFACTS / "reviewed-mb.rb")
        shutil.copyfile(
            ROOT / "ci/release-inputs.json", ARTIFACTS / "release-inputs.json"
        )

    def pour(self) -> None:
        built = read_json(ARTIFACTS / "build-evidence.json")
        require(
            built["workflow_commit"] == os.environ["GITHUB_SHA"]
            and built["run_id"] == os.environ["GITHUB_RUN_ID"],
            "Build evidence is from a different workflow run",
        )
        require(
            built["formula_sha256"] == self.inputs["stable"]["formula_sha256"]
            and built["source_commit"] == self.inputs["stable"]["commit"],
            "Build provenance differs",
        )
        require(
            built["trust_revoked"] is True
            and built["synthetic_state_unchanged"] is True,
            "Build validation was incomplete",
        )
        info = built["bottle"]
        require(built.get("completed") is True, "Bottle build did not complete")
        require(Path(info["filename"]).name == info["filename"], "Unsafe artifact name")
        require(info["tag"] == "arm64_tahoe", "Wrong bottle platform")
        bottle = ARTIFACTS / info["filename"]
        require(
            digest(bottle) == info["sha256"], "Downloaded bottle differs from the build"
        )
        require(
            digest(ARTIFACTS / "reviewed-mb.rb")
            == self.inputs["stable"]["formula_sha256"],
            "Artifact recipe differs",
        )
        # Homebrew's local-bottle loader consumes this embedded formula. Verify it
        # before loading Ruby, then use the local bottle path so no source fallback
        # can make a failed bottle masquerade as a successful install.
        with tarfile.open(bottle) as archive:
            members = [
                m for m in archive.getmembers() if m.name.endswith("/.brew/mb.rb")
            ]
            require(
                len(members) == 1 and members[0].isfile(),
                "Expected one embedded recipe",
            )
            require(
                hashlib.sha256(archive.extractfile(members[0]).read()).hexdigest()
                == self.inputs["stable"]["formula_sha256"],
                "Embedded recipe changed",
            )
        self.recipe("stable")
        self.brew("install", str(bottle))
        self.installed("2.0.0", poured=True)
        self.evidence["bottle"] = info
        self.evidence["checks"].append(
            "fresh local-bottle-only install without source fallback"
        )

    def execute(self) -> None:
        trusted = False
        completed = False
        try:
            self.prepare()
            self.brew("trust", "--formula", TARGET)
            trusted = True
            scope = json.loads(self.brew("trust", "--json=v1", capture=True))
            require(
                scope.get("formulae") == [TARGET]
                and all(not v for k, v in scope.items() if k != "formulae"),
                "Trust exceeded the single-formula scope",
            )
            (self.build if self.mode == "build" else self.pour)()
            completed = True
        finally:
            if trusted:
                self.brew("untrust", "--formula", TARGET)
            scope = json.loads(self.brew("trust", "--json=v1", capture=True))
            self.evidence["trust_revoked"] = all(
                not entries for entries in scope.values()
            )
            self.evidence["completed"] = completed
            ARTIFACTS.mkdir(exist_ok=True)
            write_json(ARTIFACTS / f"{self.mode}-evidence.json", self.evidence)
            require(self.evidence["trust_revoked"], "Formula trust was not revoked")


if __name__ == "__main__":
    require(len(sys.argv) == 2, "Specify build or pour")
    Runner(sys.argv[1], validate_inputs()).execute()
