return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      -- stages = "fade", timeout = 3000, max_width = 50, …
    })
    vim.notify = require("notify")
  end,
}

