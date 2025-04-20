return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      local next_hunk_func = function ()
          if vim.wo.diff then
            vim.cmd.normal({']h', bang = true})
          else
            gs.nav_hunk('next')
          end
        end

      local prev_hunk_func = function ()
          if vim.wo.diff then
            vim.cmd.normal({'[h', bang = true})
          else
            gs.nav_hunk('prev')
          end
        end

      map('n', ']h', next_hunk_func, "Next hunk")
      map('n', '[h', prev_hunk_func, "Prev hunk")

      -- Actions
      -- Stage
      map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

      -- Reset
      map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")


      -- Preview
      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk float")
      map('n', '<leader>hi', gs.preview_hunk_inline, "Preview hunk inline")

      -- Blame
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>hB", gs.blame, "Toggle line blame")


      -- Diff
      map("n", "<leader>hd", gs.diffthis, "Diff this")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff this ~")

      -- Quickfix
      map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
      map('n', '<leader>hq', gitsigns.setqflist)

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
    end,
  },
}
