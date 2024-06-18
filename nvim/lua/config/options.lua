-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

vim.opt.guifont = "Iosevka Fixed"

-- If using GUI versions like Neovide or Nvui, you can configure fonts like this:
if vim.fn.exists("g:neovide") then
  vim.g.neovide_font = "Iosevka Fixed"
  vim.g.neovide_font_size = 18.0
end
