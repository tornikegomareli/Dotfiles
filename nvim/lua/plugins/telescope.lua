return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require("telescope.actions")
      
      opts.defaults = vim.tbl_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            -- Navigate to next/previous result while staying in Telescope
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            
            -- Preview scrolling
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
            
            -- Navigate and preview (like Xcode)
            ["<CR>"] = actions.select_default,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            
            -- Quick navigation without closing Telescope
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          n = {
            ["<CR>"] = actions.select_default,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      })
      
      -- Specific configuration for live_grep to make it more like Xcode
      opts.pickers = vim.tbl_extend("force", opts.pickers or {}, {
        live_grep = {
          mappings = {
            i = {
              -- Open file but keep Telescope open (like Xcode preview)
              ["<C-o>"] = function(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local picker = action_state.get_current_picker(prompt_bufnr)
                local multi_selection = picker:get_multi_selection()
                
                if #multi_selection > 0 then
                  for _, entry in ipairs(multi_selection) do
                    vim.cmd("edit " .. entry.filename)
                    vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
                  end
                else
                  local selection = action_state.get_selected_entry()
                  if selection then
                    vim.cmd("edit " .. selection.filename)
                    vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
                  end
                end
              end,
            },
          },
        },
        current_buffer_fuzzy_find = {
          mappings = {
            i = {
              -- Navigate through results in buffer
              ["<CR>"] = function(prompt_bufnr)
                actions.select_default(prompt_bufnr)
              end,
            },
          },
        },
      })
      
      return opts
    end,
  },
}