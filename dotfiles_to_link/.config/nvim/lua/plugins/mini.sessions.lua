return {
  "echasnovski/mini.sessions",
  version = '*',
  config = function()
    require("mini.sessions").setup({
      autoread = false,
      autowrite = true,
    })

  end,
}
