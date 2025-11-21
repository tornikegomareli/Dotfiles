return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")

      local servers = {
        clangd = {},
        sourcekit = {
          cmd = {
            "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
          },
          root_dir = lspconfig.util.root_pattern(
            "buildServer.json",
            "*.xcodeproj",
            "*.xcworkspace",
            "Package.swift",
            ".git"
          ),
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
        zls = {},
        rust_analyzer = {},
      }

      for server, setup in pairs(servers) do
        lspconfig[server].setup(setup)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP Actions",
        callback = function(args)
          -- Once we've attached, configure the keybindings
          local wk = require("which-key")
          wk.register({
            K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP hover info" },
            gd = { "<cmd>lua vim.lsp.buf.definition()<cr>", "LSP go to definition" },
            gD = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "LSP go to declaration" },
            gi = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "LSP go to implementation" },
            gr = { "<cmd>lua vim.lsp.buf.references()<cr>", "LSP list references" },
            gs = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP signature help" },
            gn = { "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP rename" },
            ["[g"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Go to previous diagnostic" },
            ["g]"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Go to next diagnostic" },
          }, {
            mode = "n",
            -- buffer = true,
            silent = true,
          })
        end,
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        sources = {
          { name = "orgmode" },
        },
        completion = {
          completeopt = "menu,menuone,preview",
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-f>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<tab>"] = cmp.mapping(function(original)
            print("tab pressed")
            if cmp.visible() then
              print("cmp expand")
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              print("snippet expand")
              luasnip.expand_or_jump()
            else
              print("fallback")
              original()
            end
          end, { "i", "s" }),
          ["<S-tab>"] = cmp.mapping(function(original)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.jump(-1)
            else
              original()
            end
          end, { "i", "s" }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- snippets
          { name = "buffer" }, -- text within current buffer
          { name = "path" }, -- file system paths
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      })

      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require('nvim-treesitter.configs').setup({
      --   ensure_installed = 'all',
      --   ignore_install = { 'org' },
      -- })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>tt", "<cmd>Trouble quickfix toggle<cr>", { desc = "Open a quickfix" } },
    },

    opts = {},
    config = function()
      require("trouble").setup({
        auto_open = false,
        auto_close = false,
        auto_preview = true,
        auto_jump = false,
        mode = "quickfix",
        severity = vim.diagnostic.severity.ERROR,
        cycle_results = false,
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gt", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
  },
  {
    dir = "~/Development/xcede.nvim",
    name = "xcede.nvim",
    lazy = false,
    config = function()
      require("xcede").setup({
        terminal_height = 15,
        terminal_position = "vertical",
        use_floating_for_build = true,
        auto_save = true,
        auto_close_terminal = false,
        notify_on_success = true,
        notify_on_failure = true,
        use_fidget = true,
        xcbeautify = true,
        keymaps = {
          build = "<leader>xb",
          run = "<leader>xr",
          buildrun = "<leader>xR",
          test = "<leader>xt",
          toggle_terminal = "<leader>xl",
          stop = "<leader>xs",
        },
        filetypes = { "swift", "objc", "objcpp" },
      })
    end,
  },
}
