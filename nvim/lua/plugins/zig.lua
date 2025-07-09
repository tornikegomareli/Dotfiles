return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {
          settings = {
            zls = {
              enable_semantic_tokens = true,
              enable_inlay_hints = true,
              enable_snippets = true,
              enable_ast_check_diagnostics = true,
              enable_autofix = false,
              enable_import_embedfile_argument_completions = true,
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zig" })
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          local status = vim.g.zig_status
          if status then
            return status
          end
          return ""
        end,
        cond = function()
          return vim.bo.filetype == "zig"
        end,
        color = function()
          local status = vim.g.zig_status
          if status and status:match("✓") then
            return { fg = "#50fa7b" }
          elseif status and status:match("✗") then
            return { fg = "#ff5555" }
          else
            return { fg = "#f1fa8c" }
          end
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>z"] = { name = "+zig" },
      },
    },
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
  },
  {
    dir = ".",
    name = "zig-runner",
    ft = "zig",
    dependencies = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
    config = function()
      local Terminal = require("plenary.window.float").percentage_range_window
      local notify = require("notify")
      
      local zig_terminal = nil
      local zig_job_id = nil
      
      local function close_zig_terminal()
        if zig_job_id then
          vim.fn.jobstop(zig_job_id)
          zig_job_id = nil
        end
        
        if zig_terminal then
          local win_id = zig_terminal.win_id
          local bufnr = zig_terminal.bufnr
          
          -- Close the window first
          if win_id and vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
          end
          
          -- Then delete the buffer
          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
          
          zig_terminal = nil
        end
      end
      
      local function create_zig_terminal(title)
        close_zig_terminal()
        
        -- Create floating window with border
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
        
        vim.api.nvim_buf_set_option(buf, "filetype", "zig-output")
        vim.api.nvim_buf_set_option(buf, "modifiable", true)
        vim.api.nvim_win_set_option(win, "winblend", 0)
        vim.api.nvim_win_set_option(win, "wrap", false)
        vim.api.nvim_win_set_option(win, "number", false)
        vim.api.nvim_win_set_option(win, "relativenumber", false)
        vim.api.nvim_win_set_option(win, "cursorline", false)
        
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        
        vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
          callback = function()
            close_zig_terminal()
          end,
          noremap = true,
          silent = true,
        })
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
          callback = function()
            close_zig_terminal()
          end,
          noremap = true,
          silent = true,
        })
        
        return buf
      end
      
      local function append_to_buffer(buf, lines)
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
        local output_lines = {}
        
        vim.g.zig_status = "⟳ Running..."
        vim.cmd("redrawstatus")
        
        append_to_buffer(buf, { "Command: " .. cmd, "", "Output:", "─────────────────────────────────────────────────", "" })
        
        local start_time = vim.loop.hrtime()
        
        zig_job_id = vim.fn.jobstart(cmd, {
          stdout_buffered = false,
          stderr_buffered = false,
          on_stdout = function(_, data)
            if data then
              for _, line in ipairs(data) do
                if line ~= "" then
                  append_to_buffer(buf, { line })
                  table.insert(output_lines, line)
                end
              end
            end
          end,
          on_stderr = function(_, data)
            if data then
              for _, line in ipairs(data) do
                if line ~= "" then
                  append_to_buffer(buf, { "[ERROR] " .. line })
                  table.insert(output_lines, line)
                end
              end
            end
          end,
          on_exit = function(_, exit_code)
            local end_time = vim.loop.hrtime()
            local elapsed = (end_time - start_time) / 1e9
            
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
      
      local function get_zig_file()
        local file = vim.fn.expand("%:p")
        if vim.bo.filetype ~= "zig" then
          notify("Not a Zig file!", "error", { title = "Zig" })
          return nil
        end
        return file
      end
      
      vim.keymap.set("n", "<leader>zb", function()
        local file = get_zig_file()
        if file then
          run_zig_command("zig build-exe " .. file .. " -femit-bin=zig-out/bin/" .. vim.fn.expand("%:t:r"), "Zig Build")
        end
      end, { desc = "Build Zig file" })
      
      vim.keymap.set("n", "<leader>zr", function()
        local file = get_zig_file()
        if file then
          run_zig_command("zig run " .. file, "Zig Run")
        end
      end, { desc = "Run Zig file" })
      
      vim.keymap.set("n", "<leader>zt", function()
        local file = get_zig_file()
        if file then
          run_zig_command("zig test " .. file, "Zig Test")
        end
      end, { desc = "Test Zig file" })
      
      vim.keymap.set("n", "<leader>zf", function()
        local file = get_zig_file()
        if file then
          run_zig_command("zig fmt " .. file, "Zig Format")
        end
      end, { desc = "Format Zig file" })
      
      vim.keymap.set("n", "<leader>zl", function()
        if zig_terminal and vim.api.nvim_win_is_valid(zig_terminal.win_id) then
          close_zig_terminal()
        else
          notify("No Zig output to show", "warn", { title = "Zig" })
        end
      end, { desc = "Close Zig output" })
      
      vim.keymap.set("n", "<leader>zc", function()
        run_zig_command("zig build", "Zig Build Project")
      end, { desc = "Build Zig project" })
      
      -- Function to check if we're in a Zig project
      local function is_zig_project()
        local build_zig = vim.fn.findfile("build.zig", vim.fn.getcwd() .. ";")
        return build_zig ~= ""
      end
      
      -- Global keybindings for Zig build commands (only work in Zig projects)
      vim.keymap.set("n", "<D-S-B>", function()
        if is_zig_project() then
          run_zig_command("zig build", "Zig Build")
        else
          notify("Not in a Zig project (no build.zig found)", "warn", { title = "Zig" })
        end
      end, { desc = "Zig build (in project)" })
      
      vim.keymap.set("n", "<D-S-R>", function()
        if is_zig_project() then
          run_zig_command("zig build run", "Zig Build Run")
        else
          notify("Not in a Zig project (no build.zig found)", "warn", { title = "Zig" })
        end
      end, { desc = "Zig build run (in project)" })
      
      -- Toggle Zig autocompletion
      vim.g.zig_autocompletion_enabled = true
      
      vim.keymap.set("n", "<leader>za", function()
        vim.g.zig_autocompletion_enabled = not vim.g.zig_autocompletion_enabled
        local status = vim.g.zig_autocompletion_enabled and "enabled" or "disabled"
        
        -- Update completion capabilities
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
          if client.name == "zls" then
            if vim.g.zig_autocompletion_enabled then
              -- Re-enable completion
              client.server_capabilities.completionProvider = {
                resolveProvider = true,
                triggerCharacters = { ".", ":" },
              }
            else
              -- Disable completion
              client.server_capabilities.completionProvider = nil
            end
          end
        end
        
        notify("Zig autocompletion " .. status, "info", { title = "Zig" })
      end, { desc = "Toggle Zig autocompletion" })
      
      -- Auto-apply completion toggle on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
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
      
      -- Auto-format Zig files on save (disabled)
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   pattern = "*.zig",
      --   callback = function()
      --     -- Save cursor position
      --     local cursor_pos = vim.api.nvim_win_get_cursor(0)
      --     -- Format the file
      --     vim.cmd("silent! %!zig fmt --stdin")
      --     -- Restore cursor position
      --     vim.api.nvim_win_set_cursor(0, cursor_pos)
      --   end,
      -- })
      
      vim.api.nvim_create_autocmd("FileType", {
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
    end,
  },
}