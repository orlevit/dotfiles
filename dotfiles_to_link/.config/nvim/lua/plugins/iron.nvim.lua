return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")
      



      local function my_formatter(lines, extras)
        local result = {}

        -- fallback if extras is nil
        extras = extras or {}
        extras.block_dividers = extras.block_dividers or { "# %%", "#%%", "%%" }

        -- filter out lines starting with #
        for _, line in ipairs(lines) do
          if not vim.startswith(line, "#") then
            table.insert(result, line)
          end
        end

        return require("iron.fts.common").bracketed_paste_python(result, extras)
      end



      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { "bash" }
            },
            python = {
              command = { "ipython" },
              format = common.bracketed_paste_python,
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
          restart_repl = "<space>rR",
          -- send_motion = "<space>rs",
          -- visual_send = "<space>rs",
          -- send_file = "<space>rf",
          -- send_line = "<space>rl",
          -- send_paragraph = "<space>rp",
          -- send_until_cursor = "<space>ru",
          -- send_mark = "<space>rm",
          -- send_code_block = "<space>rb",
          -- send_code_block_and_move = "<space>rn",
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

      -- Override Vim behavior for the need of r won't replace text
      vim.keymap.set('n', '<space>rs', function() iron.send_motion() end, { noremap = true, silent = true })
      vim.keymap.set('v', '<space>rs', function() iron.visual_send() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<space>rs', function() iron.send_line() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<space>rf', function() iron.send_file() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<space>rp', function() iron.send_paragraph() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<space>ru', function() iron.send_until_cursor() end, { noremap = true, silent = true })
      -- vim.keymap.set('n', '<space>rm', function() iron.send_mark() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<space>rb', function() iron.send_code_block() end, { noremap = true, silent = true })
      --vim.keymap.set('n', '<space>rn', function() iron.send_code_block_and_move() end, { noremap = true, silent = true })

      -- vim.keymap.set('n', '<space>rx', function() iron.mark_motion() end, { noremap = true, silent = true })
      -- vim.keymap.set('v', '<space>rx', function() iron.mark_visual() end, { noremap = true, silent = true })
      -- vim.keymap.set('n', '<space>rd', function() iron.remove_mark() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<space>r<CR>', function() require("iron.core").send(nil, { "\n" }) end, { noremap = true, silent = true })

      vim.keymap.set('n', '<space>r<space>', function() iron.interrupt() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<space>rq', function() iron.send_quit() end, { noremap = true, silent = true })

      vim.keymap.set('n', '<space>rg', '<cmd>IronFocus<cr>')
      vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')

    end
  },
}

