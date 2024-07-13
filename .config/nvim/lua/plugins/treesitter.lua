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
                   init_selection = "<C-space>",
                   node_incremental = "<C-space>",
                   scope_incremental = false,
                   node_decremental = "<bs>",
                 },
        },
      })
    end
  }
}
