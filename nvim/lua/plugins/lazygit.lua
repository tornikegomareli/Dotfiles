-- LazyGit: floating terminal git UI. Loads on first `:LazyGit` or <leader>gt.

return {
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
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gt", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
}
