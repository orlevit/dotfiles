return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    -- build step compiles the webapp:
    build = function()
      -- this will `cd app && npm install` for you
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      -- only open to localhost (default)
      vim.g.mkdp_open_to_the_world = 0
      -- echo the preview URL in the command line
      vim.g.mkdp_echo_preview_url = 1
      -- optionally change the port:
      -- vim.g.mkdp_port = "8888"
      -- open in your system browser (e.g. firefox, chrome)
      vim.g.mkdp_browser = "firefox"
    end,
  },
}

