
-- Lazy.nvim plugin spec for persistence.nvim
return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- start session saving only after opening a file
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/", -- session files directory
      need = 1,          -- minimum buffers to save a session (0 = always)
      branch = true,     -- save sessions per git branch
    },
    config = function(_, opts)
      require("persistence").setup(opts)

      -- Keymaps for session management
      local map = vim.keymap.set
      -- Load session for current directory
      map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Load session for current dir" })
      -- Select session to load
      map("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select session to load" })
      -- Load last session
      map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Load last session" })
      -- Stop persistence (do not save session on exit)
      map("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Stop persistence" })
    end,
  },
}
