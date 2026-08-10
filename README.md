# Tornike's Dotfiles

My `~/.config` as a git repo. Clone it in place, no symlinks:

```bash
git clone https://github.com/tornikegomareli/Dotfiles.git ~/.config
```

## What I actually use

| Tool | Config | Notes |
|---|---|---|
| [Ghostty](https://ghostty.org) | `ghostty/` | Terminal. Catppuccin Latte / Cobalt2 |
| [Neovim](https://neovim.io) | `nvim/` | LazyVim base, Xcode integration via xcede.nvim |
| [Zellij](https://zellij.dev) | `zellij/` | Terminal multiplexer, custom theme |
| [herdr](https://herdr.dev) | `herdr/` | Agent multiplexer. `ctrl+p` prefix, Zellij-style pane keys |
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | `aerospace/` | Tiling WM. `ctrl+hjkl` focus, `ctrl+1..8` workspaces |
| Tilebar | `tilebar/` | My own macOS panel, workspace-aware via AeroSpace hooks |
| [lazygit](https://github.com/jesseduffield/lazygit) | `lazygit/` | Git TUI, opened from nvim and herdr |
| git | `git/` | |
| gh | `gh/` | GitHub CLI |
| [opencode](https://opencode.ai) | `opencode/` | AGENTS.md rules + herdr plugin |

Also here but rarely touched: `flutter/`, `kitty/`, `neofetch/`, `neovide/`, `yarn/`, `yazelix/`, `zed/`.

## Keybinding philosophy

One grammar everywhere: vim. AeroSpace moves between windows with `ctrl+hjkl`,
nvim moves between splits with `ctrl+hjkl`, herdr moves between panes with
`ctrl+p hjkl` or `ctrl+alt+hjkl`. Workspaces are `ctrl+1..8` in AeroSpace and
`ctrl+p 1..9` in herdr. The comments in `aerospace/aerospace.toml` and
`herdr/config.toml` document which chords each layer owns and why.

## Install script

`.install.sh` bootstraps a fresh Mac (Xcode CLI tools, Homebrew, packages).
It dates from my yabai/SketchyBar era and needs a rewrite — read it before
running, it also changes macOS system settings.
