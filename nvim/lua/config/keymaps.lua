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

--- Find files like in Xcode
---
-- lua/config/keymaps.lua

-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Add this at the bottom of the file
keymap.set("n", "<D-S-o>", function()
  require("telescope.builtin").find_files({
    hidden = true,
    no_ignore = false,
    file_ignore_patterns = {
      "%.git/.*",
      "%.xcodeproj/.*",
      "%.build/.*",
      "%.derived/.*",
      "%.swiftpm/.*",
      "DerivedData/.*",
      "%.generated/.*",
      "%.idea/.*",
      "%.gradle/.*",
      "%.spm/.*",
      "fastlane/.*",
      "Pods/.*",
    },
    previewer = false,
    layout_config = {
      height = 0.4, -- Make the window shorter
    },
  })
end, { desc = "Find files (Xcode style)" })

-- Alternative mapping if CMD+SHIFT+O doesn't work in your terminal
keymap.set("n", "<leader>xf", function()
  require("telescope.builtin").find_files({
    hidden = true,
    no_ignore = false,
    file_ignore_patterns = {
      "%.git/.*",
      "%.xcodeproj/.*",
      "%.build/.*",
      "%.derived/.*",
      "%.swiftpm/.*",
      "DerivedData/.*",
      "%.generated/.*",
      "%.idea/.*",
      "%.gradle/.*",
      "%.spm/.*",
      "fastlane/.*",
      "Pods/.*",
    },
    previewer = false,
    layout_config = {
      height = 0.4,
    },
  })
end, { desc = "Find files (Xcode style)" })

-- Add grep (search in files) like Xcode's CMD+SHIFT+F
keymap.set("n", "<D-S-f>", function()
  require("telescope.builtin").live_grep({
    additional_args = function()
      return { "--hidden" }
    end,
    file_ignore_patterns = {
      "%.git/.*",
      "%.xcodeproj/.*",
      "%.build/.*",
      "%.derived/.*",
      "%.swiftpm/.*",
      "DerivedData/.*",
      "%.generated/.*",
      "%.idea/.*",
      "%.gradle/.*",
      "%.spm/.*",
      "fastlane/.*",
      "Pods/.*",
    },
  })
end, { desc = "Search in files (Xcode style)" })

-- Alternative mapping for grep if CMD+SHIFT+F doesn't work
keymap.set("n", "<leader>xs", function()
  require("telescope.builtin").live_grep({
    additional_args = function()
      return { "--hidden" }
    end,
    file_ignore_patterns = {
      "%.git/.*",
      "%.xcodeproj/.*",
      "%.build/.*",
      "%.derived/.*",
      "%.swiftpm/.*",
      "DerivedData/.*",
      "%.generated/.*",
      "%.idea/.*",
      "%.gradle/.*",
      "%.spm/.*",
      "fastlane/.*",
      "Pods/.*",
    },
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
