-- rootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250"
vim.g.mapleader = " " -- This sets space as leader

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})
