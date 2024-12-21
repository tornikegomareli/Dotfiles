return {
  {
    "tornikegomareli/swiftbuild.nvim",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("swiftbuild").setup()
    end,
  },
}
