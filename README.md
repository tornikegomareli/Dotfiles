---

# Tornike's Dotfiles 
![Uploading Screenshot 2024-06-09 at 17.15.26.png…]()

My dotfiles repository! This repository contains my personal configurations for various tools and applications that I use in my development environment. Feel free to explore, use, and adapt these configurations for your own setup.

There is as well .install.sh file, which will automatically install and make macOS machine ready for development. 
Be carefuk and check content of script, cause I am disabling a lot of system settings from macOS system.

## Installation

To get started with these dotfiles, you can clone the repository to your home directory:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
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
- **yabai**: Configuration for Yabai, a tiling window manager for macOS.
