-- Global / cross-cutting keymaps.
--
-- Convention:
--   • Mac-style and plugin-agnostic keymaps (CMD-A/C/V, window nav, …) live here.
--   • Plugin-specific keymaps belong in the plugin's lazy `keys =` spec so
--     they participate in lazy-loading (see lua/plugins/lazygit.lua, codesnap.lua).
--   • Util-backed keymaps (claude, zig_runner) live here and call into
--     `require("util.<name>")` so the util module loads on first use.
--
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set
local opts_silent = { noremap = true, silent = true }

-- ─── Quick-open this config ──────────────────────────────────────────────
-- Drops you into the plugins/ directory listing (netrw) so you can pick one.
map("n", "<leader>fed", function()
  vim.cmd("edit ~/.config/nvim/lua/plugins/")
end, { desc = "Open plugins/ directory" })

-- ─── Mac-style editing (CMD = <D-…>) ─────────────────────────────────────
-- These mirror standard macOS shortcuts so muscle memory from other editors
-- carries over. They use the system clipboard ("+) for copy / paste / cut.

-- Select all
map("n", "<D-a>", "ggVG", opts_silent)
map("i", "<D-a>", "<Esc>ggVG", opts_silent)
map("v", "<D-a>", "<Esc>ggVG", opts_silent)

-- Undo (works in insert / visual too by briefly leaving the mode)
map("n", "<D-z>", "u", opts_silent)
map("i", "<D-z>", "<C-o>u", opts_silent)
map("v", "<D-z>", "<C-o>u", opts_silent)

-- Copy / Paste / Cut to system clipboard
map("n", "<D-c>", '"+y', opts_silent)
map("v", "<D-c>", '"+y', opts_silent)
map("i", "<D-c>", '<Esc>"+y', opts_silent)

map("n", "<D-v>", '"+p', opts_silent)
map("v", "<D-v>", '"+p', opts_silent)
map("i", "<D-v>", '<Esc>"+pa', opts_silent)

map("n", "<D-x>", '"+d', opts_silent)
map("v", "<D-x>", '"+d', opts_silent)
map("i", "<D-x>", '<Esc>"+da', opts_silent)

-- Save
map("n", "<D-s>", ":w<CR>", opts_silent)
map("i", "<D-s>", "<C-\\><C-n>:w<CR>", opts_silent)

-- ─── Comfort mappings ────────────────────────────────────────────────────
map("n", ";", ":", { desc = "Enter command mode without Shift" })
map("i", "jk", "<ESC>", { desc = "Escape via jk" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "LSP hover" })

-- Jump back to previous cursor location (matches Xcode's CMD-§).
map("n", "gb", "<C-o>", opts_silent)
map("n", "<D-§>", "<C-o>", opts_silent)

-- LazyVim sometimes changes cwd; we let autocmds.lua manage it.
vim.opt.autochdir = true

-- ─── Window navigation (Ctrl + hjkl) ─────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ─── Search navigation (Xcode-like CMD-G / CMD-Shift-G) ──────────────────
map("n", "<D-g>", "n", { desc = "Next search result" })
map("n", "<D-S-g>", "N", { desc = "Previous search result" })

-- ─── LSP definition in splits ────────────────────────────────────────────
map(
  "n",
  "gv",
  "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>",
  { desc = "Definition in vertical split" }
)
map("n", "gs", function()
  vim.cmd("split")
  vim.lsp.buf.definition()
end, { desc = "Definition in horizontal split" })

-- ─── NvimTree (Xcode CMD-Shift-J reveal-in-tree) ─────────────────────────
map("n", "<D-S-J>", ":NvimTreeFindFileToggle<CR>", opts_silent)

-- ─── Search-and-replace helpers ──────────────────────────────────────────
-- <leader>sr: replace the current search register interactively.
map("n", "<leader>sr", function()
  local search_term = vim.fn.getreg("/")
  local replacement = vim.fn.input("Replace " .. search_term .. " with: ")
  if replacement ~= "" then
    vim.cmd("%s/" .. search_term .. "/" .. replacement .. "/gc")
  end
end, { desc = "Replace current search term" })

-- <leader>qr: replace across files in the quickfix list (cfdo).
map("n", "<leader>qr", function()
  local search_term = vim.fn.input("Search for: ")
  if search_term == "" then
    return
  end
  local replacement = vim.fn.input("Replace with: ")
  if replacement == "" then
    return
  end
  vim.cmd("cfdo %s/" .. search_term .. "/" .. replacement .. "/gc")
end, { desc = "Replace in quickfix list" })

-- ─── Quickfix navigation ─────────────────────────────────────────────────
map("n", "<leader>cn", ":cnext<CR>", { desc = "Next quickfix item" })
map("n", "<leader>cp", ":cprev<CR>", { desc = "Previous quickfix item" })
map("n", "<leader>co", ":copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix list" })

-- ─── FzfLua quick pickers ────────────────────────────────────────────────
map("n", "<D-f>", "<cmd>FzfLua blines<CR>", { desc = "Find in buffer" })
map("n", "<C-f>", "<cmd>FzfLua blines<CR>", { desc = "Find in buffer" })
map("n", "<D-O>", "<cmd>FzfLua files<CR>", { desc = "Find files" })
map("n", "<D-r>", "<cmd>FzfLua oldfiles<CR>", { desc = "Recent files" })

-- ─── Xcode-style search (git-root, excludes build artifacts) ─────────────
-- One source of truth for the exclude list and the git-root resolution.
-- Used by find-files (<D-S-O>, <leader>xf) and live-grep (<D-S-f>, <leader>xs).
local function git_root_or_cwd()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    return vim.fn.getcwd()
  end
  return root
end

-- Build-artifact / vendor directories we never want to search.
local SEARCH_EXCLUDES = {
  ".git",
  ".xcodeproj",
  ".build",
  ".derived",
  ".swiftpm",
  "DerivedData",
  ".generated",
  ".idea",
  ".gradle",
  ".spm",
  "fastlane",
  "Pods",
}

local function fd_opts_string()
  local out = "--type f --hidden"
  for _, e in ipairs(SEARCH_EXCLUDES) do
    out = out .. " --exclude " .. e
  end
  return out
end

local function rg_opts_string()
  local out = "--column --line-number --no-heading --color=always --smart-case --hidden"
  for _, e in ipairs(SEARCH_EXCLUDES) do
    out = out .. " -g '!" .. e .. "'"
  end
  return out
end

local function xcode_find_files()
  require("fzf-lua").files({
    cwd = git_root_or_cwd(),
    fd_opts = fd_opts_string(),
    previewer = false,
    winopts = { height = 0.4, width = 0.8 },
  })
end

local function xcode_live_grep()
  require("fzf-lua").live_grep({
    cwd = git_root_or_cwd(),
    rg_opts = rg_opts_string(),
  })
end

map("n", "<D-S-o>", xcode_find_files, { desc = "Find files (Xcode style)" })
map("n", "<leader>xf", xcode_find_files, { desc = "Find files (Xcode style)" })
map("n", "<D-S-f>", xcode_live_grep, { desc = "Search in files (Xcode style)" })
map("n", "<leader>xs", xcode_live_grep, { desc = "Search in files (Xcode style)" })

-- ─── Claude Code (util/claude.lua) ───────────────────────────────────────
map("n", "<leader>ai", function()
  require("util.claude").toggle()
end, { desc = "Toggle Claude Code" })

map("n", "<leader>aI", function()
  require("util.claude").restart()
end, { desc = "Restart Claude Code (new prompt)" })

-- <D-i> works from normal / insert / terminal modes. We leave terminal-insert
-- first so the toggle can manipulate the host window cleanly.
map({ "n", "i", "t" }, "<D-i>", function()
  if vim.fn.mode() == "t" then
    vim.cmd("stopinsert")
  end
  require("util.claude").toggle()
end, { desc = "Toggle Claude Code" })

-- ─── Zig (util/zig_runner.lua) ───────────────────────────────────────────
-- <leader>z… are buffer-aware (file vs. project). <D-S-B>/<D-S-R> are
-- project-only and notify if no build.zig is found.
local function zig()
  return require("util.zig_runner")
end

map("n", "<leader>zb", function() zig().build() end, { desc = "Zig: build" })
map("n", "<leader>zr", function() zig().run() end, { desc = "Zig: run" })
map("n", "<leader>zt", function() zig().test() end, { desc = "Zig: test file" })
map("n", "<leader>zf", function() zig().format() end, { desc = "Zig: format file" })
map("n", "<leader>zl", function() zig().close() end, { desc = "Zig: close output" })
map("n", "<leader>zc", function() zig().build_project_only() end, { desc = "Zig: build project" })
map("n", "<leader>za", function() zig().toggle_autocompletion() end, { desc = "Zig: toggle autocompletion" })

map("n", "<D-S-B>", function() zig().build_project_only() end, { desc = "Zig: build (project)" })
map("n", "<D-S-R>", function() zig().run_project_only() end, { desc = "Zig: build run (project)" })
