# MB Homebrew tap

[MB](https://github.com/jthingelstad/mb) is a Micro.blog command-line client
and local MCP server for agents.

## Install

```sh
brew install jthingelstad/mb/mb
```

MB is pure Python. It runs on Homebrew's `python@3.14` and uses Homebrew's own
`pydantic`, `rpds-py`, `cryptography` and `certifi`, so nothing is compiled
during install. Bottles are built for:

- macOS 15 (Sequoia) and later on Apple Silicon
- Linux on x86_64 and arm64

Other platforms Homebrew supports can build from source, which takes a minute or two.

## Set up

Create an app token on Micro.blog under **Account → Edit Apps**, then:

```sh
pbpaste | mb auth -     # reads the token from stdin, keeping it out of shell history
mb doctor               # checks the install, PATH, config, token and blog
```

`mb doctor` warns when another `mb`, for example an older uv or pipx install,
comes ahead of Homebrew's in your `PATH`.

## Use with Claude

Claude Code:

```sh
claude mcp add mb -- mb mcp --consumer claude-code --read-only
```

Leave out `--read-only` once you want the agent to be able to post. For Claude
Desktop and other clients, see the
[MCP guide](https://github.com/jthingelstad/mb/blob/main/docs/mcp.md).

Installing MB does not read credentials, change configuration, register MCP
clients or publish anything. Each of those is a step you take.

## Upgrade and uninstall

```sh
brew upgrade mb
brew uninstall mb
brew untap jthingelstad/mb
```

Uninstalling leaves your configuration and receipt store in `~/.config/mb/`.

## Releases

- [MB release notes](https://github.com/jthingelstad/mb/releases)
- The 2.0.0 bottle and its verification evidence are kept on the
  [mb-v2.0.0 release](https://github.com/jthingelstad/homebrew-mb/releases/tag/mb-v2.0.0)
