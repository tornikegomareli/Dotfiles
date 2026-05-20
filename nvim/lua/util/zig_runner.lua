-- Zig task runner: build / run / test / format in a floating output window.
-- Public surface (used from lua/config/keymaps.lua):
--   M.build(), M.run(), M.test(), M.format()  — project-aware where it matters
--   M.close()                                 — close the output window
--   M.is_project()                            — true iff a build.zig is reachable from cwd
--   M.toggle_autocompletion()                 — flip zls completion on/off
--
-- The `zig-output` filetype highlighting and `BufWritePre` format-on-save
-- autocmds live in lua/config/autocmds.lua so all autocmds are co-located.

local M = {}

-- Single output window at a time. We kill the previous job when starting a
-- new one so progress notifications stay accurate.
local zig_terminal = nil
local zig_job_id = nil

vim.g.zig_autocompletion_enabled = vim.g.zig_autocompletion_enabled ~= false

local function notify(msg, level, opts)
  require("notify")(msg, level, opts)
end

local function close_zig_terminal()
  if zig_job_id then
    vim.fn.jobstop(zig_job_id)
    zig_job_id = nil
  end

  if zig_terminal then
    local win_id = zig_terminal.win_id
    local bufnr = zig_terminal.bufnr

    if win_id and vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_win_close(win_id, true)
    end
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end

    zig_terminal = nil
  end
end

local function create_zig_terminal(title)
  close_zig_terminal()

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })

  zig_terminal = { win_id = win, bufnr = buf }

  -- `zig-output` filetype is matched by an autocmd in autocmds.lua that
  -- installs the colour highlights for command/success/error lines.
  vim.api.nvim_buf_set_option(buf, "filetype", "zig-output")
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_win_set_option(win, "winblend", 0)
  vim.api.nvim_win_set_option(win, "wrap", false)
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "cursorline", false)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  -- q / Esc inside the output buffer closes the window.
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    callback = close_zig_terminal,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
    callback = close_zig_terminal,
    noremap = true,
    silent = true,
  })

  return buf
end

local function append_to_buffer(buf, lines)
  -- jobstart callbacks fire outside the main loop; wrap with vim.schedule
  -- to satisfy the "API calls must run in the main loop" contract.
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(buf) then
      local last_line = vim.api.nvim_buf_line_count(buf)
      vim.api.nvim_buf_set_lines(buf, last_line, last_line, false, lines)

      if zig_terminal and vim.api.nvim_win_is_valid(zig_terminal.win_id) then
        vim.api.nvim_win_set_cursor(zig_terminal.win_id, { vim.api.nvim_buf_line_count(buf), 0 })
      end
    end
  end)
end

local function run_zig_command(cmd, title)
  local buf = create_zig_terminal(title)

  vim.g.zig_status = "⟳ Running..."
  vim.cmd("redrawstatus")

  append_to_buffer(buf, {
    "Command: " .. cmd,
    "",
    "Output:",
    "─────────────────────────────────────────────────",
    "",
  })

  local start_time = vim.loop.hrtime()

  zig_job_id = vim.fn.jobstart({ "sh", "-c", cmd }, {
    stdout_buffered = false,
    stderr_buffered = false,
    pty = true,
    cwd = vim.fn.getcwd(),
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            append_to_buffer(buf, { line })
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            append_to_buffer(buf, { line })
          end
        end
      end
    end,
    on_exit = function(_, exit_code)
      local elapsed = (vim.loop.hrtime() - start_time) / 1e9

      append_to_buffer(buf, { "", "─────────────────────────────────────────────────" })

      if exit_code == 0 then
        vim.g.zig_status = "✓ Success"
        append_to_buffer(buf, {
          "✓ " .. title .. " completed successfully",
          "Time: " .. string.format("%.3fs", elapsed),
          "─────────────────────────────────────────────────",
        })
        notify(title .. " succeeded in " .. string.format("%.3fs", elapsed), "info", {
          title = "Zig",
          timeout = 2000,
        })
      else
        vim.g.zig_status = "✗ Failed"
        append_to_buffer(buf, {
          "✗ " .. title .. " failed with exit code: " .. exit_code,
          "Time: " .. string.format("%.3fs", elapsed),
          "─────────────────────────────────────────────────",
        })
        notify(title .. " failed with exit code: " .. exit_code, "error", {
          title = "Zig",
          timeout = 3000,
        })
      end

      vim.cmd("redrawstatus")
      zig_job_id = nil
    end,
  })
end

local function current_zig_file()
  local file = vim.fn.expand("%:p")
  if vim.bo.filetype ~= "zig" then
    notify("Not a Zig file!", "error", { title = "Zig" })
    return nil
  end
  return file
end

function M.is_project()
  return vim.fn.findfile("build.zig", vim.fn.getcwd() .. ";") ~= ""
end

-- `zig build` for projects, `zig build-exe` for ad-hoc single files.
function M.build()
  if M.is_project() then
    run_zig_command("zig build", "Zig Build")
  else
    local file = current_zig_file()
    if file then
      run_zig_command(
        "zig build-exe " .. file .. " -femit-bin=zig-out/bin/" .. vim.fn.expand("%:t:r"),
        "Zig Build"
      )
    end
  end
end

function M.run()
  if M.is_project() then
    run_zig_command("zig build run", "Zig Build Run")
  else
    local file = current_zig_file()
    if file then
      run_zig_command("zig run " .. file, "Zig Run")
    end
  end
end

function M.test()
  local file = current_zig_file()
  if file then
    run_zig_command("zig test " .. file, "Zig Test")
  end
end

function M.format()
  local file = current_zig_file()
  if file then
    run_zig_command("zig fmt " .. file, "Zig Format")
  end
end

function M.close()
  if zig_terminal and vim.api.nvim_win_is_valid(zig_terminal.win_id) then
    close_zig_terminal()
  else
    notify("No Zig output to show", "warn", { title = "Zig" })
  end
end

function M.build_project_only()
  if M.is_project() then
    run_zig_command("zig build", "Zig Build")
  else
    notify("Not in a Zig project (no build.zig found)", "warn", { title = "Zig" })
  end
end

function M.run_project_only()
  if M.is_project() then
    run_zig_command("zig build run", "Zig Build Run")
  else
    notify("Not in a Zig project (no build.zig found)", "warn", { title = "Zig" })
  end
end

-- Flips the global flag and reaches into the attached zls clients to add/
-- remove completion capability live (no restart needed).
function M.toggle_autocompletion()
  vim.g.zig_autocompletion_enabled = not vim.g.zig_autocompletion_enabled
  local status = vim.g.zig_autocompletion_enabled and "enabled" or "disabled"

  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.name == "zls" then
      if vim.g.zig_autocompletion_enabled then
        client.server_capabilities.completionProvider = {
          resolveProvider = true,
          triggerCharacters = { ".", ":" },
        }
      else
        client.server_capabilities.completionProvider = nil
      end
    end
  end

  notify("Zig autocompletion " .. status, "info", { title = "Zig" })
end

return M
