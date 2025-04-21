return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("todo-comments")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Fuzzy find files in cwd" })
      vim.keymap.set("n", "<leader>tg", builtin.live_grep, { desc = "Find string in cwd" })
      vim.keymap.set("n", "<leader>to", builtin.oldfiles, { desc = "Fuzzy find recent files" })
      vim.keymap.set("n", "<leader>tc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
      vim.keymap.set("n", "<leader>tk", builtin.keymaps, { desc = "Find keymaps" })
      vim.keymap.set("n", "<leader>tb", builtin.buffers, { desc = "Find among open buffers" })
      vim.keymap.set("n", "<leader>tm", builtin.buffers, { desc = "Find marks" })
      vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  end,
}
