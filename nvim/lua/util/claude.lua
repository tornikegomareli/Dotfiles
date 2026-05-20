-- Claude Code launcher: opens `claude` in a centred floating terminal.
-- Public surface (used from lua/config/keymaps.lua):
--   M.toggle()   — show/hide the window; prompts for a session on first use
--   M.restart()  — close existing window and prompt for a fresh session

local M = {}

-- One window/buffer at a time. The window can be hidden (kept alive) or
-- destroyed entirely (forces a fresh session on next toggle).
local state = { buf = nil, win = nil }

local function win_opts()
  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.85)
  return {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Claude ",
    title_pos = "center",
  }
end

local function reset_state()
  state.buf, state.win = nil, nil
end

local function start_claude(cmd)
  state.buf = vim.api.nvim_create_buf(false, true)
  state.win = vim.api.nvim_open_win(state.buf, true, win_opts())
  vim.fn.termopen(cmd, {
    on_exit = function()
      -- Tear everything down when `claude` exits so the next toggle starts fresh.
      if state.win and vim.api.nvim_win_is_valid(state.win) then
        pcall(vim.api.nvim_win_close, state.win, true)
      end
      if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
      end
      reset_state()
    end,
  })
  vim.cmd("startinsert")
end

local function prompt_and_start()
  vim.ui.select(
    { "Continue last session", "New session", "Resume (pick session)" },
    { prompt = "Claude Code:" },
    function(choice)
      if not choice then
        return
      end
      local cmd = ({
        ["Continue last session"] = "claude --continue",
        ["New session"] = "claude",
        ["Resume (pick session)"] = "claude --resume",
      })[choice]
      start_claude(cmd)
    end
  )
end

function M.toggle()
  -- If a window already exists, just flip its hidden flag — preserves the
  -- terminal session so toggling away and back doesn't lose context.
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    local cfg = vim.api.nvim_win_get_config(state.win)
    if cfg.hide then
      vim.api.nvim_win_set_config(state.win, { hide = false })
      vim.api.nvim_set_current_win(state.win)
      vim.cmd("startinsert")
    else
      vim.api.nvim_win_set_config(state.win, { hide = true })
    end
    return
  end
  prompt_and_start()
end

function M.restart()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end
  reset_state()
  prompt_and_start()
end

return M
