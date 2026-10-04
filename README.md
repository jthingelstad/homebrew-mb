# MB Homebrew tap

MB is a Micro.blog command-line client and local MCP server designed for agents.
This tap packages MB **2.0.0** with the MCP extra in a private Python environment.

The verified distribution targets **Apple Silicon on macOS 26** with Homebrew's
default **`/opt/homebrew`** prefix. macOS 27, Intel, Linux and other prefixes have
not been certified by these tests.

## Install

On the verified platform:

```sh
brew tap jthingelstad/mb
brew trust --formula jthingelstad/mb/mb
brew install --force-bottle jthingelstad/mb/mb
```

The formula-specific trust step permits Homebrew to load this tap's Ruby recipe.
`--force-bottle` requires the published prebuilt package and prevents a source
build from masking a bottle problem. Check `brew list --versions jthingelstad/mb/mb`
for the installed version and `command -v mb` for the executable your shell uses.
An existing uv or pipx installation can take precedence in `PATH`.

Authentication and MCP client registration are separate setup steps. Installation
does not read or copy credentials, change MB configuration or receipt stores,
register clients, change cron, or publish Micro.blog content. See the
[source project](https://github.com/jthingelstad/mb),
[2.0 migration guide](https://github.com/jthingelstad/mb/blob/v2.0.0/docs/migration-2.0.md)
and [MCP setup/contracts](https://github.com/jthingelstad/mb/blob/v2.0.0/docs/mcp.md).

## Verified release

- [MB 2.0.0 source/wheel release](https://github.com/jthingelstad/mb/releases/tag/v2.0.0)
- [Exact bottle, checksums and retained evidence](https://github.com/jthingelstad/homebrew-mb/releases/tag/mb-v2.0.0)
- [Cold source installation, RC4-to-stable upgrade and fresh bottle pour](https://github.com/jthingelstad/homebrew-mb/actions/runs/37242182828)
- [Published tap/URL bottle installation and installed tests](https://github.com/jthingelstad/homebrew-mb/actions/runs/37243818182)

Source commit: `34263c38b5e76037b8d71ab0409427e6fefe82a8`.
The bottle has the actual `arm64_tahoe` tag, verified rebuild/cellar metadata,
and SHA256 `52f92c7dee24a5eda8f1fb0e8d19df29bc6521a9bb0c72be07030244ec62e934`.

The installed tests cover CLI help/guidance and no-auth refusal; a real local
stdio MCP handshake with all 23 typed tools; JPEG/WebP support; native-order
catchup and acknowledgement with nonmonotonic IDs; synthetic media-to-draft
operations, receipt replay and human CLI recovery; source/dependency hashes and
native linkage. The upgrade preserves synthetic external profiles, checkpoints
and applied/unknown receipts byte for byte. These tests use fake transport and
state and perform no live Micro.blog writes or acknowledgements.

## Build and trust boundaries

Workflows run only when manually dispatched, on standard disposable macOS 26
Apple Silicon runners, with `contents: read` and pinned GitHub actions. They
cannot publish releases, push commits or approve pull requests. There is no
automatic release updater or publisher.

The source build freezes the Homebrew framework and official core formula tree,
verifies native source/bottle versions and hashes, and records the installed
dependency graph, compiler and SDK. Python build isolation resolves checksummed
local source archives under constraints; Cargo resolves checksummed vendored
sources offline with lock enforcement. Native CMake and Ninja avoid nested
backend downloads. The build/test sandbox denies network access after resource
fetching. This is tested input control, not a claim of byte-identical builds.

The fresh-pour gate verifies same-run provenance, archive SHA and the embedded
frozen recipe before allowing one local-bottle loader invocation; it restores
Homebrew's path guard before tests. The public-install gate uses the normal
remote bottle URL and cannot fall back to source compilation. Published bottle
metadata must be canonical; removing it must recover the exact frozen recipe
body and hash.

Each job uses an isolated configuration and grants trust to this single formula.
Cleanup revokes the grant and verifies an empty trust scope on success or
failure. Temporary Actions artifacts expire after three days; release evidence
is retained with the public bottle. No paid runners or automated write-token
permissions are configured.
