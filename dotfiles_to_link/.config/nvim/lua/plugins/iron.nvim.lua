return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")
      



      local python_format = require("iron.fts.common").bracketed_paste_python

      iron.setup {
        config = {
          scratch_repl = false,
          repl_definition = {
            sh = {
              command = { "bash" }
            },
            python = {
             -- command = { "ipython" },
                -- command = { "jupyter-console"},
            command = { 'ipython', '--no-autoindent' },

              format = python_format, -- common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%", "##" },
            }
          },
          repl_filetype = function(bufnr, ft)
            return ft
          end,
          repl_open_cmd = view.split.vertical("40%"),
        },
keymaps = {
          toggle_repl = "<space>rr",
          -- restart_repl = "<space>rR",
          -- send_motion = "<space>rs",
          -- visual_send = "<space>rs",
          -- send_file = "<space>rf",
          -- send_line = "<space>rl",
          -- send_paragraph = "<space>rp",
          -- send_until_cursor = "<space>ru",
          -- send_mark = "<space>rm",
          send_code_block = "<space>bc",
          send_code_block_and_move = "<space>bn",
          -- mark_motion = "<space>mc",
          -- mark_visual = "<space>mc",
          -- remove_mark = "<space>md",
          -- cr = "<space>s<cr>",
          -- interrupt = "<space>s<space>",
          -- exit = "<space>sq",
          -- clear = "<space>cl",
        },
        highlight = {
          italic = true
        },
        ignore_blank_lines = true,
      }
      -- Proper restart that kills old process
      vim.keymap.set('n', '<space>rR', function()
        local ft = vim.bo.filetype
        -- First close the REPL properly
        require("iron.core").close_repl(ft)
        -- Wait a moment for cleanup
        vim.defer_fn(function()
          require("iron.core").repl_for(ft)
        end, 100)
      end, { noremap = true, silent = true, desc = "Restart REPL" })
      -- Override Vim behavior for the need of r won't replace text
      vim.keymap.set('n', '<space>rs', function() iron.send_motion() end, { noremap = true, silent = true, desc = "Send motion to REPL" })
      vim.keymap.set('v', '<space>rs', function() iron.visual_send() end, { noremap = true, silent = true, desc = "Send visual selection to REPL" })
      vim.keymap.set('n', '<space>rs', function() iron.send_line() end, { noremap = true, silent = true, desc = "Send line to REPL" })
      vim.keymap.set('n', '<space>rf', function() iron.send_file() end, { noremap = true, silent = true, desc = "Send file to REPL" })
      vim.keymap.set('n', '<space>rp', function() iron.send_paragraph() end, { noremap = true, silent = true, desc = "Send paragraph to REPL" })
      vim.keymap.set('n', '<space>ru', function() iron.send_until_cursor() end, { noremap = true, silent = true, desc = "Send until cursor to REPL" })
      -- vim.keymap.set('n', '<space>rm', function() iron.send_mark() end, { noremap = true, silent = true, desc = "Send mark to REPL" })
      -- vim.keymap.set('n', '<space>rb', function() iron.send_code_block() end, { noremap = true, silent = true, desc = "Send code block to REPL" })
      -- vim.keymap.set('n', '<space>rn', function() iron.send_code_block_and_move() end, { noremap = true, silent = true, desc = "Send code block and move to REPL" })
      -- vim.keymap.set('n', '<space>rx', function() iron.mark_motion() end, { noremap = true, silent = true, desc = "Mark motion for REPL" })
      -- vim.keymap.set('v', '<space>rx', function() iron.mark_visual() end, { noremap = true, silent = true, desc = "Mark visual selection for REPL" })
      -- vim.keymap.set('n', '<space>rd', function() iron.remove_mark() end, { noremap = true, silent = true, desc = "Remove REPL mark" })
      vim.keymap.set('n', '<space>r<CR>', function() require("iron.core").send(nil, { "\n" }) end, { noremap = true, silent = true, desc = "Send newline to REPL" })
      vim.keymap.set('n', '<space>r<space>', function() iron.interrupt() end, { noremap = true, silent = true, desc = "Interrupt REPL" })
      vim.keymap.set('n', '<space>rq', function() iron.send_quit() end, { noremap = true, silent = true, desc = "Send quit to REPL" })
      vim.keymap.set('n', '<space>rg', '<cmd>IronFocus<cr>', { desc = "Focus REPL" })
      vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>', { desc = "Hide REPL" })

    end
  },
}
