-- LSP stack: lspconfig (servers), fidget (progress UI), nvim-cmp (completion).
-- Servers configured: clangd, sourcekit (Swift/ObjC), zls (Zig), rust-analyzer.
-- Buffer-local LSP keymaps are bound in the LspAttach autocmd below.

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")

      local servers = {
        clangd = {},
        sourcekit = {
          -- Use Xcode's bundled sourcekit-lsp so the version matches the
          -- selected Xcode (avoids drift with Apple SDK / Swift toolchain).
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

      -- Register LSP keymaps only after a server attaches, so they don't
      -- clobber defaults on buffers without LSP.
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP buffer-local keymaps",
        callback = function(args)
          local wk = require("which-key")
          wk.register({
            K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP hover info" },
            gd = { "<cmd>lua vim.lsp.buf.definition()<cr>", "LSP go to definition" },
            gD = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "LSP go to declaration" },
            gi = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "LSP go to implementation" },
            gr = { "<cmd>lua vim.lsp.buf.references()<cr>", "LSP list references" },
            gs = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP signature help" },
            gn = { "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP rename" },
            ["[g"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous diagnostic" },
            ["g]"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next diagnostic" },
          }, {
            mode = "n",
            silent = true,
          })
        end,
      })
    end,
  },

  -- Status-line spinner for in-flight LSP requests.
  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  -- Completion engine + sources + snippet engine + VSCode-like icons.
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          -- `select = false` + Replace: pressing <CR> without a manual
          -- selection inserts a literal newline instead of the first item.
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
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
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
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
}
