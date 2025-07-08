local function get_system_appearance()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") and "dark" or "light"
  end
  return "dark"
end

local function get_theme_for_appearance()
  local appearance = get_system_appearance()
  if appearance == "light" then
    return "catppuccin-latte"
  else
    return "catppuccin-frappe"
  end
end

return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "neanias/everforest-nvim" },
  { "rose-pine/neovim" },
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

  -- Configure LazyVim to load theme based on system appearance
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = get_theme_for_appearance(),
    },
  },
  
  -- Auto-switch theme on system appearance change
  {
    "f-person/auto-dark-mode.nvim",
    priority = 1000,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
        vim.cmd("colorscheme everforest")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
        vim.cmd("colorscheme catppuccin-latte")
      end,
    },
  },
}
