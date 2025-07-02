return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      local lsp = vim.lsp
      local handlers = {
        ["textDocument/hover"] = lsp.with(lsp.handlers.hover, borders),
        ["txtdocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, borders),
      }

      local servers = {
        clangd = {},
        sourcekit = {
          root_dir = lspconfig.util.root_pattern(".git", "Package.swift", "compile_commands.json"),
        },
        zls = {},
        lspconfig.rust_analyzer.setup({}),
      }

      for server, setup in pairs(servers) do
        setup.handlers = handlers
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
    "wojciech-kulik/xcodebuild.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua", -- (optional) to manage project files
      "stevearc/oil.nvim", -- (optional) to manage project files
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("xcodebuild").setup({
        show_build_progress_bar = true,
        logs = {
          auto_open_on_success_tests = false,
          auto_open_on_failed_tests = false,
          auto_open_on_success_build = false,
          auto_open_on_failed_build = false,
          auto_focus = false,
          auto_close_on_app_launch = true,
          only_summary = true,
          notify = function(message, severity)
            local fidget = require("fidget")
            if progress_handle then
              progress_handle.message = message
              if not message:find("Loading") then
                progress_handle:finish()
                progress_handle = nil
                if vim.trim(message) ~= "" then
                  fidget.notify(message, severity)
                end
              end
            else
              fidget.notify(message, severity)
            end
          end,
          notify_progress = function(message)
            local progress = require("fidget.progress")

            if progress_handle then
              progress_handle.title = ""
              progress_handle.message = message
            else
              progress_handle = progress.handle.create({
                message = message,
                lsp_client = { name = "xcodebuild.nvim" },
              })
            end
          end,
        },
        code_coverage = {
          enabled = true,
        },
      })

    -- stylua: ignore start
    vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
    vim.keymap.set("n", "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })

    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
    vim.keymap.set("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })

    vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
    vim.keymap.set("v", "<leader>xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
    vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })

    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
    vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" })
    vim.keymap.set("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
    vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })

    vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
    vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
    vim.keymap.set("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })

    vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
    vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })
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
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
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
}
