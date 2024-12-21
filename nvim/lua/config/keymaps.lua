-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Functions
local open_plugins_lua = function()
  vim.cmd("edit ~/.config/nvim/lua/plugins/example.lua")
end
-- Functions

-- vim.api.nvim_set_keymap("n", "<leader>fp", ":Telescope projects<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-f>", ":Telescope current_buffer_fuzzy_find<CR>", { noremap = true, silent = true })

-- Find files like it is in Xcode
vim.api.nvim_set_keymap("n", "<D-O>", ":Telescope find_files<CR>", { noremap = true, silent = true })
--

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")

-- Text Selecting
-- Map Cmd + A to select all text
vim.api.nvim_set_keymap("n", "<D-a>", "ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- Map Cmd + Z to undo
vim.api.nvim_set_keymap("n", "<D-z>", "u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-z>", "<C-o>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-z>", "<C-o>u", { noremap = true, silent = true })

-- Map Cmd + C to copy visually selected text to the system clipboard
vim.api.nvim_set_keymap("n", "<D-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-c>", '<Esc>"+y', { noremap = true, silent = true })

-- Map Cmd + V to paste text from the system clipboard
vim.api.nvim_set_keymap("n", "<D-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-v>", '<Esc>"+pa', { noremap = true, silent = true })

-- Map Cmd + X to cut visually selected text to the system clipboard
vim.api.nvim_set_keymap("n", "<D-x>", '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-x>", '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-x>", '<Esc>"+da', { noremap = true, silent = true })
-- Text Selecting
--
--
-- Macos Xcode CMD SHIFT J to open triggered file in project navigator

vim.api.nvim_set_keymap("n", "<D-S-J>", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fed", open_plugins_lua, { desc = "Open plugins.lua" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>"
--

vim.api.nvim_set_keymap("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-s>", "<C-\\><C-n>:w<CR>", { noremap = true, silent = true })

-- Map gb to go back to the previous location
vim.api.nvim_set_keymap("n", "gb", "<C-o>", { noremap = true, silent = true })

vim.opt.autochdir = true
