-- All autocmds live here. Loaded on the VeryLazy event by LazyVim.
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- ─── Working-directory lock ───────────────────────────────────────────────
-- LazyVim auto-`cd`s to a detected project root on every buffer switch.
-- We want the launch directory to stay sticky (so file pickers, terminals,
-- and ad-hoc shell commands all operate from a predictable cwd). This
-- autocmd snaps cwd back to the initial directory on every BufEnter/LspAttach.
-- Remove this block if you want LazyVim's default per-buffer root behaviour.
local initial_cwd = vim.fn.getcwd()
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  desc = "Pin cwd to the directory nvim was launched from",
  callback = function()
    if vim.fn.getcwd() ~= initial_cwd then
      vim.cmd("cd " .. initial_cwd)
    end
  end,
})

-- ─── Editor UX ─────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Briefly highlight the yanked region",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "No line numbers in terminal buffers",
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    local win = vim.api.nvim_get_current_win()
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
  end,
})

-- ─── Filetype-specific tweaks ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  desc = "Markdown: no spellcheck",
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Swift: 2-space indent, Xcode-like cinoptions",
  pattern = "swift",
  callback = function()
    vim.opt_local.cindent = true
    vim.opt_local.cinoptions = "L0"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- ─── Xcodebuild → Trouble integration ─────────────────────────────────────
-- After a build/test run, open the Trouble quickfix view on failure, close
-- it on success. Tied to events fired by the xcodebuild/xcede plugins.
vim.api.nvim_create_autocmd("User", {
  desc = "Show Trouble quickfix when xcodebuild reports failures",
  pattern = { "XcodebuildBuildFinished", "XcodebuildTestsFinished" },
  callback = function(event)
    if event.data.cancelled then
      return
    end
    if event.data.success then
      require("trouble").close()
    elseif not event.data.failedCount or event.data.failedCount > 0 then
      if next(vim.fn.getqflist()) then
        require("trouble").open("quickfix")
      else
        require("trouble").close()
      end
      require("trouble").refresh()
    end
  end,
})

-- ─── Zig autocmds ──────────────────────────────────────────────────────────
-- Format on save (uses `zig fmt --stdin`, preserves cursor position).
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Zig: auto-format on save",
  pattern = "*.zig",
  callback = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("silent! %!zig fmt --stdin")
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})

-- Honour the global completion toggle (see util.zig_runner.toggle_autocompletion).
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Zig: apply autocompletion toggle to zls",
  pattern = "*.zig",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "zls" then
      if not vim.g.zig_autocompletion_enabled then
        client.server_capabilities.completionProvider = nil
      end
    end
  end,
})

-- Syntax highlighting for the zig-runner output buffer (filetype set by util.zig_runner).
vim.api.nvim_create_autocmd("FileType", {
  desc = "Zig runner output: colourise success/error/separator lines",
  pattern = "zig-output",
  callback = function()
    vim.cmd([[
      syntax match ZigOutputSeparator /^─\+$/
      syntax match ZigOutputSuccess /^✓.*/
      syntax match ZigOutputError /^✗.*/
      syntax match ZigOutputError /^\[ERROR\].*/
      syntax match ZigOutputCommand /^Command:.*/
      syntax match ZigOutputTime /^Time:.*/
      syntax match ZigOutputHeader /^Output:$/

      highlight ZigOutputSeparator guifg=#44475a
      highlight ZigOutputSuccess guifg=#50fa7b
      highlight ZigOutputError guifg=#ff5555
      highlight ZigOutputCommand guifg=#8be9fd
      highlight ZigOutputTime guifg=#f1fa8c
      highlight ZigOutputHeader guifg=#bd93f9 gui=bold
    ]])
  end,
})
