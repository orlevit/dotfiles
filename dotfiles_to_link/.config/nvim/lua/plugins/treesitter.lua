return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", "windwp/nvim-ts-autotag" },
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true }, -- enable autotagging (w/ nvim-ts-autotag plugin)
        ensure_installed = {
          "python",
          "lua",
          "html",
          "yaml",
          "dockerfile",
          "vim",
          "markdown",
          "json",
          "bash",
          "gitignore",
          "markdown",
          "markdown_inline",
        },
        -- incremental_selection = {
        --   enable = true,
        --   keymaps = {
        --     init_selection = "<leader>v", -- start selection
        --     node_incremental = "u", -- increment node
        --     scope_incremental = false, -- increment scope
        --     node_decremental = "m", -- decrement node
        --   },
        -- },
      })
    end,
  },
}
