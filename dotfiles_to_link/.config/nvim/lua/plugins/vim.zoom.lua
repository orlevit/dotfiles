return {
    "dhruvasagar/vim-zoom",
    lazy = false,
    keys = {
      { "<C-w>z", "<Plug>(zoom-toggle)", desc = "Zoom toggle current window" },
    },
    init = function()
      vim.g["zoom#statustext"] = ""
    end
  }
