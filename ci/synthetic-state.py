"""Seed/check synthetic external user state only; never contacts Micro.blog."""

import json
from pathlib import Path
import sys
import tomllib
from mb.state import StateStore
import mb.config as config_api

root = Path(sys.argv[1])
root.mkdir(parents=True, exist_ok=True)
config = root / "config.toml"
state = root / "state.sqlite"
if not config.exists():
    config.write_text(
        '[default]\nusername="synthetic"\nblog="https://synthetic.invalid/"\ncheckpoint=1\nheartbeat_checkpoint=2\ninbox_checkpoint=3\ncatchup_checkpoint=4\n[other]\nusername="synthetic-other"\nblog="https://other.invalid/"\ncheckpoint=5\n'
    )
    store = StateStore(state)
    store.acknowledge("synthetic-consumer", "9", 0, native=True)
    for oid, outcome in [
        ("applied-example", "applied"),
        ("unknown-example", "unknown"),
    ]:
        store.claim("synthetic-blog", oid, "fingerprint-" + oid)
        store.finish(
            "synthetic-blog",
            oid,
            {"ok": outcome == "applied", "outcome": outcome, "operation_id": oid},
        )
else:
    store = StateStore(state)
    assert store.cursor("synthetic-consumer") == ("9", 1)
    assert store.cursor_record("synthetic-consumer")["scheme"] == "native-order-v1"
    assert (
        store.lookup(
            "synthetic-blog", "applied-example", "fingerprint-applied-example"
        )["outcome"]
        == "applied"
    )
    assert (
        store.lookup(
            "synthetic-blog", "unknown-example", "fingerprint-unknown-example"
        )["outcome"]
        == "unknown"
    )
    assert tomllib.loads(config.read_text())["default"]["catchup_checkpoint"] == 4
config_api.CONFIG_FILE = config
assert config_api.list_named_checkpoints() == {
    "timeline": 1,
    "heartbeat": 2,
    "inbox": 3,
    "catchup": 4,
}
assert config_api.get_named_checkpoint("timeline", profile="other") == 5
assert config_api.get_username("default") == "synthetic"
assert config_api.get_username("other") == "synthetic-other"
print(
    json.dumps(
        {
            "synthetic_profiles": 2,
            "cli_checkpoints": 4,
            "native_anchor": "9",
            "receipts": ["applied", "unknown"],
        }
    )
)
