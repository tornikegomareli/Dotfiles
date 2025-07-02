-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Setting Font and Size
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:b:h18"
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
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_smooth_blink = false
end
