return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    config = function()
      local cmp = require("cmp")

      -- Setup copilot
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            dismiss = "<M-h>",
            next = "<M-j>",
            prev = "<M-k>",
          },
        },
        panel = {
          enabled = true,
        },
        filetypes = {
          markdown = true,
          help = true,
        },
      })
      --
      -- -- Set cmp placement dynamically
      -- local function set_cmp_placement(pos)
      --         local current_config = cmp.get_config()
      --         local new_cop_config = current_config
      --         new_cop_config.window.completion.placement = pos
      --         cmp.setup(new_cop_config)
      --       end
      --
      -- set_cmp_placement("top")

    end,
  },
}
