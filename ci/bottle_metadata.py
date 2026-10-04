"""Validate declarative bottle metadata without extending the reviewed recipe body."""

import hashlib
import json
from pathlib import Path
import re

ROOT_URL = "https://github.com/jthingelstad/homebrew-mb/releases/download/mb-v2.0.0"
PUBLIC_FILENAME = "mb-2.0.0.arm64_tahoe.bottle.1.tar.gz"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


def canonical_bottle_block(public: dict) -> str:
    bottle = public["bottle"]
    require(
        public["source_and_fresh_pour_passed"] is True, "Publication gates incomplete"
    )
    require(bottle["tag"] == "arm64_tahoe", "Unverified bottle platform")
    require(bottle["root_url"] == ROOT_URL, "Unexpected bottle release root")
    require(bottle["filename"] == PUBLIC_FILENAME, "Unexpected public bottle filename")
    require(bottle["url"] == ROOT_URL + "/" + PUBLIC_FILENAME, "Unexpected bottle URL")
    require(bottle["rebuild"] == 1, "Unexpected bottle rebuild")
    require(
        bool(re.fullmatch(r"[0-9a-f]{64}", bottle["sha256"])), "Invalid bottle SHA256"
    )
    cellar = bottle["cellar"]
    require(
        cellar in {"any", "any_skip_relocation", "/opt/homebrew/Cellar"},
        "Unexpected bottle cellar",
    )
    cellar_literal = ":" + cellar if cellar.startswith("any") else json.dumps(cellar)
    return (
        "  bottle do\n"
        f'    root_url "{ROOT_URL}"\n'
        "    rebuild 1\n"
        f'    sha256 cellar: {cellar_literal}, arm64_tahoe: "{bottle["sha256"]}"\n'
        "  end\n\n"
    )


def reviewed_recipe(
    path: Path, expected_sha: str, public_path: Path, source_commit: str
) -> bytes:
    data = path.read_bytes()
    if hashlib.sha256(data).hexdigest() == expected_sha:
        return data
    public = json.loads(public_path.read_text())
    require(public["source_commit"] == source_commit, "Published source commit changed")
    require(
        public["source_recipe_sha256"] == expected_sha, "Source recipe grant changed"
    )
    require(
        hashlib.sha256(data).hexdigest() == public["formula_sha256"],
        "Published formula SHA256 changed",
    )
    block = canonical_bottle_block(public).encode()
    require(
        public["bottle_block"].encode() == block, "Bottle declaration is not canonical"
    )
    require(
        data.count(b"  bottle do\n") == 1 and data.count(block) == 1,
        "Expected one exact bottle declaration",
    )
    body = data.replace(block, b"", 1)
    require(
        hashlib.sha256(body).hexdigest() == expected_sha,
        "Frozen source recipe body changed",
    )
    return body
