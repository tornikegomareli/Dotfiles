-- Zig support: LSP (zls), treesitter, lualine status, which-key group.
-- The custom build/run/test runner lives in lua/util/zig_runner.lua;
-- its keymaps live in lua/config/keymaps.lua; its autocmds (format-on-save,
-- LspAttach toggle, output-buffer highlighting) live in lua/config/autocmds.lua.

return {
  -- Ensure zls is installed via Mason.
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zls" })
    end,
  },

  -- zls LSP options (semantic tokens, inlay hints, etc.).
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

  -- Treesitter grammar for Zig.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zig" })
      end
    end,
  },

  -- Lualine slot showing zig-runner status (running / success / failure).
  -- Reads vim.g.zig_status, which util.zig_runner sets during builds.
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return vim.g.zig_status or ""
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

  -- which-key namespace for <leader>z…
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>z", group = "zig" },
      },
    },
  },

  -- Runtime deps used by util.zig_runner; declared explicitly so they're
  -- guaranteed to be available when the runner is first invoked.
  { "nvim-lua/plenary.nvim", lazy = true },
  { "rcarriga/nvim-notify", lazy = true },
}
