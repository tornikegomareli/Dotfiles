-- Colourscheme stack.
--
-- Active themes:
--   dark  → carbonfox (from nightfox.nvim)
--   light → catppuccin-latte
--
-- Switching is driven by auto-dark-mode.nvim, which polls macOS appearance.
-- The other theme plugins below are kept available for ad-hoc `:colorscheme`
-- browsing — remove any you don't want to keep installed.

return {
  -- Extra themes available via `:colorscheme <name>`.
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "neanias/everforest-nvim" },
  { "rose-pine/neovim" },
  { "savq/melange-nvim" },
  { "nyoom-engineering/oxocarbon.nvim", priority = 1000 },

  -- Light theme. `priority = 1000` ensures it loads before other UI plugins
  -- so their highlight groups inherit the right palette.
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = true,
      },
    },
  },

  -- Dark theme provider (carbonfox is one of the nightfox variants).
  { "EdenEast/nightfox.nvim", priority = 1000 },

  -- Tell LazyVim which colourscheme to use at startup. auto-dark-mode below
  -- overrides this dynamically once it knows the system appearance.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },

  -- Bridge macOS appearance → :colorscheme. Polls every `update_interval` ms.
  {
    "f-person/auto-dark-mode.nvim",
    priority = 1000,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd("colorscheme carbonfox")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd("colorscheme catppuccin-latte")
      end,
    },
  },
}
