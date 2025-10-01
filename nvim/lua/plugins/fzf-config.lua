return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = {
        -- Enable syntax highlighting in previews
        delay = 100,
        winopts = {
          number = false,
          relativenumber = false,
          cursorline = true,
          cursorcolumn = false,
          scrolloff = 3,
        },
      },
    },
    files = {
      -- Enable colored icons
      git_icons = true,
      file_icons = true,
      color_icons = true,
    },
    grep = {
      -- Enable syntax highlighting for grep results
      multiprocess = true,
      git_icons = true,
      file_icons = true,
      color_icons = true,
      -- Use bat for previews if available for better syntax highlighting
      previewer = "bat",
    },
    previewers = {
      bat = {
        cmd = "bat",
        args = "--style=numbers,changes --color always",
        theme = "ansi",
      },
    },
  },
}