return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
                 enable = true,
                 keymaps = {
                       init_selection = "<leader>s",        -- Start selection
                       node_incremental = "<leader>s",     -- Increment node
                       scope_incremental = false,   -- Increment scope
                       node_decremental = "<bs>",          -- Decrement node
                 },
        },
      })
    end,
  }
}
