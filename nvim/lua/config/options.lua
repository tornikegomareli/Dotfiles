-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Setting Font and Size
vim.opt.guifont = "Monaspace Krypton Medium:h18"
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
