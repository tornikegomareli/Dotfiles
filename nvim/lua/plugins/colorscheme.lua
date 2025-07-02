local theme_name = "everforest"  -- Change this to your preferred theme

return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "neanias/everforest-nvim" },
  { "rose-pine/neovim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme_name,
    },
  },
}
