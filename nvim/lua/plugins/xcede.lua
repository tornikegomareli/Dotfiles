-- xcede.nvim: local Xcode integration (build / run / test from within nvim).
-- Loaded from ~/Development/xcede.nvim. See lua/config/autocmds.lua for the
-- xcodebuild-finished → Trouble integration.

return {
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
