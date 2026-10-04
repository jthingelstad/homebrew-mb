# MB Homebrew tap

MB is a Micro.blog command-line client and local MCP server designed for agents.
This tap includes the MCP extra in a private Python environment.

**Preparation status:** the 2.0.0 recipes are prepared; the hosted source build,
RC4-to-stable upgrade and fresh bottle pour have not run. No stable bottle or
verified public installation command is available yet.

The initial verification target is Apple Silicon on macOS 26, using Homebrew's
default `/opt/homebrew` prefix. Other macOS releases, Intel and Linux are not
certified by this workflow. A successful macOS 26 run does not certify macOS 27.

After a bottle release is published and its build/pour evidence is linked here,
the intended installation sequence is:

```sh
brew tap jthingelstad/mb
brew trust --formula jthingelstad/mb/mb
brew install jthingelstad/mb/mb
```

Do not present that sequence as verified availability while this preparation
notice remains. Authentication is a separate MB setup step; this tap never reads
or copies an existing token, configuration, or receipt store.

## Verification

The manually dispatched workflow runs with `contents: read`, uses pinned GitHub
actions, and publishes no releases or commits. It pins the Homebrew framework,
checks the native dependency versions/source and bottle hashes, then installs
core native bottles. It verifies a source installation of the last RC, a real
upgrade to stable, installed source hashes and runtime versions, synthetic state
preservation, the installed CLI/MCP/media functional tests, and linkage.

A second fresh runner consumes the same-run artifact. It checks the bottle SHA
and embedded recipe before loading it, installs the local bottle without source
fallback, and repeats the installed tests and linkage checks.

Python build backends resolve from checksummed local source archives under build
constraints. Cargo uses a checksummed vendor bundle, offline mode and locked
resolution. Declared Homebrew CMake and Ninja avoid Python backend tool
bootstrapping. The macOS build/test sandbox denies network access; resource
downloads occur before the build. These controls require a successful cold run
to establish their behavior. They do not claim bit-for-bit reproducibility.

Trust is restricted to this formula in a fresh runner configuration directory.
The driver checks both reviewed recipe hashes before use, revokes the grant in
cleanup, and records the final empty trust scope. Runner teardown also removes
the temporary configuration after cancellation.

Artifacts have a three-day retention period. No paid runners, package registry,
personal access tokens, automatic pull requests, or automated repository writes
are configured. Native dependency drift fails verification and requires review.

Source project: <https://github.com/jthingelstad/mb>.
