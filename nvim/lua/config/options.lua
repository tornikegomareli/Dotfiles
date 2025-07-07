-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Setting Font and Size
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:b:h20"
--21/12/2024
--

-- Setting Default Picker, Telescope instead of fzf
vim.g.lazyvim_picker = "telescope"
--21/12/2024

-- Brackets and some formatting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  callback = function()
    vim.opt_local.cindent = true
    vim.opt_local.cinoptions = "L0"
    vim.opt_local.shiftwidth = 2 -- Set indent to 2 spaces
    vim.opt_local.tabstop = 2 -- Set tab to 2 spaces
    vim.opt_local.softtabstop = 2 -- Set soft tab to 2 spaces
  end,
})

--21/12/2024

-- Set NVim default working directory, whenever file opened
vim.opt.autochdir = true
--21/12/2024

-- Use absolute line numbers only (no relative numbers)
vim.opt.number = true
vim.opt.relativenumber = false

-- Neovide settings (disable cursor animations)
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
  vim.g.neovide_transparency = 0.7
  vim.g.neovide_window_blurred = true
  vim.g.neovide_font_hinting = "full"
  vim.g.neovide_font_edging = "antialias"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_fullscreen = false
  vim.g.neovide_remember_window_position = true
end
