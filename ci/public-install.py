"""Verify the published formula/URL after source-upgrade and fresh-pour gates.

Runs only on the same approved disposable hosted platform. Publication and token
permissions remain separate; this script performs no release or repository writes.
"""

from copy import deepcopy
import hashlib
import importlib.util
import json
import os
from pathlib import Path

import bottle_metadata

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("bottle_ci", ROOT / "ci/bottle-ci.py")
driver = importlib.util.module_from_spec(spec)
spec.loader.exec_module(driver)

inputs = driver.read_json(ROOT / "ci/release-inputs.json")
public = driver.read_json(ROOT / "ci/public-release.json")
driver.require(
    os.environ.get("EXPECTED_FORMULA_SHA256") == public["formula_sha256"],
    "Published recipe dispatch hash differs",
)
driver.require(
    os.environ.get("EXPECTED_BOTTLE_SHA256") == public["bottle"]["sha256"],
    "Published bottle dispatch hash differs",
)
formula = ROOT / "Formula/mb.rb"
driver.require(
    driver.digest(formula) == public["formula_sha256"], "Published recipe changed"
)
block = bottle_metadata.canonical_bottle_block(public)
driver.require(
    block == public["bottle_block"],
    "Bottle declaration differs from reviewed release metadata",
)
source = bottle_metadata.reviewed_recipe(
    formula,
    inputs["stable"]["formula_sha256"],
    ROOT / "ci/public-release.json",
    inputs["stable"]["commit"],
)
driver.require(
    hashlib.sha256(source).hexdigest() == inputs["stable"]["formula_sha256"],
    "Published recipe body differs from frozen source-tested recipe",
)
driver.require(
    public["source_commit"] == inputs["stable"]["commit"], "Published source differs"
)
driver.require(
    public["source_and_fresh_pour_passed"] is True,
    "Required publication gates are incomplete",
)
driver.require(public["bottle"]["tag"] == "arm64_tahoe", "Unverified platform")

# Runner.prepare independently checks the tap at the exact workflow commit and
# the frozen official framework/core/native inputs before formula-specific trust.
reviewed = deepcopy(inputs)
reviewed["stable"]["formula_sha256"] = public["formula_sha256"]
runner = driver.Runner("pour", reviewed)
runner.evidence["mode"] = "public-install"
runner.evidence["source_recipe_sha256"] = inputs["stable"]["formula_sha256"]
runner.evidence["bottle"] = public["bottle"]
trusted = False
completed = False
try:
    runner.prepare()
    runner.brew("trust", "--formula", driver.TARGET)
    trusted = True
    scope = json.loads(runner.brew("trust", "--json=v1", capture=True))
    driver.require(
        scope.get("formulae") == [driver.TARGET]
        and all(not values for key, values in scope.items() if key != "formulae"),
        "Trust exceeded one formula",
    )
    runner.recipe("stable")
    info = json.loads(runner.brew("info", "--json=v2", driver.TARGET, capture=True))[
        "formulae"
    ][0]
    bottle = info["bottle"]["stable"]["files"]["arm64_tahoe"]
    driver.require(
        bottle["sha256"] == public["bottle"]["sha256"], "Declared bottle hash differs"
    )
    driver.require(
        bottle["url"] == public["bottle"]["url"], "Declared public bottle URL differs"
    )
    # Use the published tap's normal remote bottle downloader, without a local
    # archive or source fallback. This is the exact final advertised command.
    runner.brew("install", "--force-bottle", driver.TARGET)
    runner.installed("2.0.0", poured=True)
    runner.evidence["install_commands"] = [
        "brew tap jthingelstad/mb",
        "brew trust --formula jthingelstad/mb/mb",
        "brew install --force-bottle jthingelstad/mb/mb",
    ]
    completed = True
finally:
    if trusted:
        runner.brew("untrust", "--formula", driver.TARGET)
    scope = json.loads(runner.brew("trust", "--json=v1", capture=True))
    runner.evidence["trust_revoked"] = all(not values for values in scope.values())
    runner.evidence["completed"] = completed
    driver.ARTIFACTS.mkdir(exist_ok=True)
    driver.write_json(
        driver.ARTIFACTS / "public-install-evidence.json", runner.evidence
    )
    driver.require(runner.evidence["trust_revoked"], "Formula trust was not revoked")
