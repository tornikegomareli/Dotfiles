-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Functions
local open_plugins_lua = function()
  vim.cmd("edit ~/.config/nvim/lua/plugins/example.lua")
end
-- Functions

-- vim.api.nvim_set_keymap("n", "<leader>fp", ":Telescope projects<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-f>", "<cmd>FzfLua blines<CR>", { noremap = true, silent = true, desc = "Find in buffer" })
vim.api.nvim_set_keymap("n", "<C-f>", "<cmd>FzfLua blines<CR>", { noremap = true, silent = true, desc = "Find in buffer" })

-- Find files like it is in Xcode
vim.api.nvim_set_keymap("n", "<D-O>", "<cmd>FzfLua files<CR>", { noremap = true, silent = true, desc = "Find files" })

-- Open recent files
vim.api.nvim_set_keymap("n", "<D-r>", "<cmd>FzfLua oldfiles<CR>", { noremap = true, silent = true, desc = "Recent files" })
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
vim.api.nvim_set_keymap("n", "gb", "<C-o>", { noremap = true, silent = true })

-- Map Cmd-§ to also go back to the previous location
vim.api.nvim_set_keymap("n", "<D-§>", "<C-o>", { noremap = true, silent = true })

vim.opt.autochdir = true

--- Find files like in Xcode
---
-- lua/config/keymaps.lua

-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Add this at the bottom of the file
keymap.set("n", "<D-S-o>", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    git_root = vim.fn.getcwd()
  end
  require("fzf-lua").files({
    cwd = git_root,
    fd_opts = "--type f --hidden --exclude .git --exclude .xcodeproj --exclude .build --exclude .derived --exclude .swiftpm --exclude DerivedData --exclude .generated --exclude .idea --exclude .gradle --exclude .spm --exclude fastlane --exclude Pods",
    previewer = false,
    winopts = {
      height = 0.4,
      width = 0.8,
    },
  })
end, { desc = "Find files (Xcode style)" })

-- Alternative mapping if CMD+SHIFT+O doesn't work in your terminal
keymap.set("n", "<leader>xf", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    git_root = vim.fn.getcwd()
  end
  require("fzf-lua").files({
    cwd = git_root,
    fd_opts = "--type f --hidden --exclude .git --exclude .xcodeproj --exclude .build --exclude .derived --exclude .swiftpm --exclude DerivedData --exclude .generated --exclude .idea --exclude .gradle --exclude .spm --exclude fastlane --exclude Pods",
    previewer = false,
    winopts = {
      height = 0.4,
      width = 0.8,
    },
  })
end, { desc = "Find files (Xcode style)" })

-- Add grep (search in files) like Xcode's CMD+SHIFT+F
keymap.set("n", "<D-S-f>", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    git_root = vim.fn.getcwd()
  end
  require("fzf-lua").live_grep({
    cwd = git_root,
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden -g '!.git' -g '!.xcodeproj' -g '!.build' -g '!.derived' -g '!.swiftpm' -g '!DerivedData' -g '!.generated' -g '!.idea' -g '!.gradle' -g '!.spm' -g '!fastlane' -g '!Pods'",
  })
end, { desc = "Search in files (Xcode style)" })

-- Alternative mapping for grep if CMD+SHIFT+F doesn't work
keymap.set("n", "<leader>xs", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    git_root = vim.fn.getcwd()
  end
  require("fzf-lua").live_grep({
    cwd = git_root,
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden -g '!.git' -g '!.xcodeproj' -g '!.build' -g '!.derived' -g '!.swiftpm' -g '!DerivedData' -g '!.generated' -g '!.idea' -g '!.gradle' -g '!.spm' -g '!fastlane' -g '!Pods'",
  })
end, { desc = "Search in files (Xcode style)" })

-- Add a keymap for the actual replace operation
vim.keymap.set("n", "<leader>sr", function()
  -- Get the current search term from the search register
  local search_term = vim.fn.getreg("/")

  -- Prompt for replacement term
  local replacement = vim.fn.input("Replace " .. search_term .. " with: ")

  if replacement ~= "" then
    -- Execute the replacement
    vim.cmd("%s/" .. search_term .. "/" .. replacement .. "/gc")
  end
end, { desc = "Replace current search term" })

-- Replace in quickfix list
vim.keymap.set("n", "<leader>qr", function()
  local search_term = vim.fn.input("Search for: ")
  if search_term == "" then
    return
  end

  local replacement = vim.fn.input("Replace with: ")
  if replacement == "" then
    return
  end

  -- Replace in quickfix list
  vim.cmd("cfdo %s/" .. search_term .. "/" .. replacement .. "/gc")
end, { desc = "Replace in quickfix list" })

-- LSP Go to Definition in splits
-- Use gv for vertical split (or choose another key combination)
vim.keymap.set(
  "n",
  "gv",
  "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>",
  { desc = "Go to definition in vertical split" }
)

-- Use gs for horizontal split
vim.keymap.set("n", "gs", function()
  vim.cmd("split")
  vim.lsp.buf.definition()
end, { desc = "Go to definition in horizontal split" })

-- Search navigation (like Xcode)
-- After searching with / or ?, use these to navigate
vim.keymap.set("n", "<D-g>", "n", { desc = "Go to next search result" })
vim.keymap.set("n", "<D-S-g>", "N", { desc = "Go to previous search result" })

-- For quickfix navigation (after Telescope sends results to quickfix)
vim.keymap.set("n", "<leader>cn", ":cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", ":cprev<CR>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>co", ":copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix list" })

-- Window navigation (Ctrl + hjkl)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
