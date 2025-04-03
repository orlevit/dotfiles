return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  opts = {
    enable = true,
    max_lines = 2, -- how many context lines to show
    trim_scope = "outer",
    mode = "cursor", -- update on cursor move
  }
}
