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
                       init_selection = "<leader>v",        -- start selection
                       node_incremental = "u",     -- increment node
                       scope_incremental = false,   -- increment scope
                       node_decremental = "m",          -- decrement node
                 },
        },
      })
    end,
  }
}
