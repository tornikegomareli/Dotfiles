## Tornike's Dotfiles 
<img src="https://github.com/tornikegomareli/Dotfiles/blob/main/Screenshot%202024-06-09%20at%2017.15.26.png" width="350" height="350" alt="Example Image">

My dotfiles repository! This repository contains my personal configurations for various tools and applications that I use in my development environment. Feel free to explore, use, and adapt these configurations for your own setup.

There is as well .install.sh file, which will automatically install and make macOS machine ready for development. 
Be carefuk and check content of script, cause I am disabling a lot of system settings from macOS system.

## Installation

To get started with these dotfiles, you can clone the repository to your home directory:

```bash
git clone https://github.com/tornikegomareli/dotfiles.git ~/.config
cd ~/.config
```

Then, you can symlink the configuration files to their appropriate locations. For example:

```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/kitty ~/.config/kitty
# Add more symlinks as needed
```

This repository contains configuration files for the following tools:

- **borders**: Configuration for window borders.
- **iterm2**: Configuration for iTerm2 terminal emulator.
- **kitty**: Configuration for Kitty terminal emulator.
- **neofetch**: Configuration for Neofetch, a system information tool.
- **nvim**: Configuration for Neovim, a text editor.
- **sketchybar**: Configuration for SketchyBar, a customizable macOS menu bar.
- **sketchybar_backup**: Backup configuration for SketchyBar.
- **yabai**: Configuration for Yabai, a tiling window manager for macOS. And SKHD for managin Yabai with productive shortucts
