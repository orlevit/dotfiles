return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Jump forward to the nearest textobject
          keymaps = {
            ["af"] = "@function.outer", -- around function
            ["if"] = "@function.inner", -- inside function
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      }
    }
  end,
}

