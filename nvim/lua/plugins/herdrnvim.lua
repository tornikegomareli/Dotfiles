-- Review agent-authored diffs from herdr. Local checkout while developing.
-- Not lazy-loaded: the herdr review pane starts nvim and immediately calls
-- require("herdrnvim").start(), and the review keymaps have to already exist.
return {
  {
    dir = vim.fn.expand("~/Development/herdrnvim"),
    name = "herdrnvim",
    dependencies = { "sindrets/diffview.nvim" },
    lazy = false,
    opts = {},
  },
}
