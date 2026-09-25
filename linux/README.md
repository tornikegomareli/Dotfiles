# Linux setup

Apps and tools to install on Linux so the setup matches the Mac. This list comes from the macOS `Brewfile`, app launch counts, and the configs in this repo. macOS-only apps are left out.

## Configs

Link every config directory in this repo into `~/.config`, except these macOS-only ones:

- `aerospace` (macOS window manager)
- `tilebar` (macOS menu bar)
- `zed` (not used on Linux)

## Desktop apps

| App | Use |
|---|---|
| Ghostty | Main terminal |
| kitty | Second terminal |
| Neovide | Neovim GUI |
| Google Chrome | Browser |
| Telegram | Chat |
| Slack | Chat |
| Discord | Chat |
| Obsidian | Notes |
| Claude | AI chat (official Linux beta, Ubuntu 22.04+ and Debian 12+) |
| ChatGPT | AI chat (official Linux preview) |
| Termius | SSH client |
| pgAdmin 4 | Postgres GUI |
| Spotify | Music |
| Docker | Containers |

## Terminal tools

- **Workspace:** neovim, herdr, zellij, yazelix, lazygit, tmux.
- **Shell:** fzf, ripgrep, fd, bat, git-delta, btop, starship.
- **Runtimes:** mise, uv.
- **Network:** tailscale.
- **Git:** git, gh.

## AI agents

Install these with npm:

- `@anthropic-ai/claude-code`
- `@openai/codex`
- `@google/gemini-cli`
- `@earendil-works/pi-coding-agent`

Also install `opencode`. Its config is in `opencode/`.

## Herdr plugins

`herdr/plugins.json` lists the installed plugins with their source repo and pinned commit.

- Install `jhochenbaum.hunkdiff` and `persiyanov.reviewr` from GitHub. Do not copy the macOS plugin builds.
- Clone `tgomareli.launcher` from `github.com/tornikegomareli/herdr-launcher` into `~/Development/herdr-launcher`.
- The launcher needs `herdr/plugins/config/tgomareli.launcher/.env` with `TYPESAFE_API_KEY`. This file is not in git. Copy it from the Mac by hand.
- `tgomareli.herdrnvim` and `tgomareli.tempo` are local plugins. Their source is not on the Mac or in git, so skip them. `nvim/lua/plugins/herdrnvim.lua` loads `~/Development/herdrnvim`, so that plugin fails until the source exists.

## Skipped

These apps have no Linux version, or you do not use them on Linux:

- **No Linux version:** Xcode, RocketSim, AeroSpace, Tilebar, Maccy, Screen Studio, Dia, Talkify, and the macOS Finder and Calendar apps.
- **Not used on Linux:** Figma, CapCut, Zed.
- **WhatsApp:** no official Linux app. Use WhatsApp Web in the browser.
