local theme_name = "everforest"

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
