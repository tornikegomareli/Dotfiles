-- Editor options. Loaded by LazyVim BEFORE lazy.setup evaluates plugin specs,
-- which is why `mapleader` must be set here (not in init.lua) — otherwise
-- plugin `keys =` tables resolve <leader> against the wrong key.
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Leader must be set before any plugin keymap references it.
vim.g.mapleader = " "

-- Default picker (overrides LazyVim's choice).
vim.g.lazyvim_picker = "telescope"

-- Font (GUI clients: Neovide, etc.)
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:b:h20"

-- Editor behaviour
vim.opt.swapfile = false
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250"

-- Line numbers: absolute only.
vim.opt.number = true
vim.opt.relativenumber = false

-- Folding off by default; we open files fully expanded.
vim.opt.foldcolumn = "0"
vim.opt.foldenable = false
vim.opt.fillchars = "eob: "
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.signcolumn = "yes"
vim.opt.statuscolumn = ""
vim.opt.list = false

-- Neovide-specific settings (no-op when running in a terminal).
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_position_animation_length = 0.1
  vim.g.neovide_cursor_smooth_blink = true
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h20:b"
  vim.g.neovide_show_menubar = true
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_window_blurred = true
  vim.g.neovide_font_hinting = "full"
  vim.g.neovide_font_edging = "antialias"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_fullscreen = false
  vim.g.neovide_remember_window_position = true
end
