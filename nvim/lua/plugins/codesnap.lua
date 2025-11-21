return {
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight", "CodeSnapSaveHighlight", "CodeSnapASCII" },
    keys = {
      { "<leader>cs", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save code snapshot to clipboard" },
      { "<leader>cc", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save code snapshot to ~/Desktop" },
      { "<leader>ch", "<cmd>CodeSnapHighlight<cr>", mode = "x", desc = "Save highlighted snapshot to clipboard" },
      { "<leader>cH", "<cmd>CodeSnapSaveHighlight<cr>", mode = "x", desc = "Save highlighted snapshot to file" },
      { "<leader>ca", "<cmd>CodeSnapASCII<cr>", mode = "x", desc = "Copy ASCII snapshot to clipboard" },
    },
    config = function()
      require("codesnap").setup({
        mac_window_bar = false,
        title = "CodeSnap.nvim",
        code_font_family = "CaskaydiaCove Nerd Font",
        watermark_font_family = "CaskaydiaCove Nerd Font",
        watermark = "@tornikegomareli",
        bg_color = "#0F0E0E",
        breadcrumbs_separator = "/",
        has_breadcrumbs = false,
        has_line_number = false,
        show_workspace = false,
        min_width = 0,
        bg_x_padding = 122,
        bg_y_padding = 82,
        save_path = "~/Desktop",
      })
    end,
  },
}
