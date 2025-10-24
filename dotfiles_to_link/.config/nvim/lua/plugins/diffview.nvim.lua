return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()


    -- Global Diffview commands
    local keymap = vim.keymap
    keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history (current)" })
    keymap.set("n", "<leader>dH", "<cmd>DiffviewFileHistory<cr>", { desc = "File history (all)" })
    keymap.set("n", "<leader>dr", "<cmd>DiffviewRefresh<cr>", { desc = "Refresh Diffview" })

    local actions = require("diffview.actions")
    
    require("diffview").setup({
      enhanced_diff_hl = false, -- Better diff highlighting
      
      view = {
        -- Show file info in winbar
        default = { winbar_info = true },
        merge_tool = { winbar_info = true },
        file_history = { winbar_info = true },
      },

      hooks = {
        diff_buf_read = function(bufnr)
          -- Called once when each new diff buffer is created
          -- The diff buffer is already the current buffer
          
          vim.opt_local.wrap = false           -- No line wrapping → see full lines
          vim.opt_local.list = false           -- Hide invisible chars → less noise
          vim.opt_local.colorcolumn = ""       -- No length marker → cleaner view
          vim.opt_local.relativenumber = false -- Absolute numbers → easier reference
        end,
      },

      -- NOTE: Existing Neovim keymaps
      -- do - Obtain (get) changes from the other buffer (diff obtain)
      -- dp - Put changes to the other buffer (diff put)
      keymaps = {
        view = {
          -- Hunk navigation
          { "n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({"]c", bang = true})
            end
          end, { desc = "Next hunk" } },
          
          { "n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({"[c", bang = true})
            end
          end, { desc = "Previous hunk" } },
        }
      },
    })
  end
}
