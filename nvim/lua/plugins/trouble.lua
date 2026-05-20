-- Trouble: prettier diagnostics / quickfix viewer.
-- Opened by the xcodebuild-finished autocmd in lua/config/autocmds.lua on failure.

return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>tt", "<cmd>Trouble quickfix toggle<cr>", desc = "Toggle quickfix" },
    },
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
}
