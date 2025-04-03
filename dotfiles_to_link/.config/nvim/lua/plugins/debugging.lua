return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Make sure nvim-nio is installed before nvim-dap-ui:
    -- No config needed here—just ensure it's present
    { "nvim-neotest/nvim-nio" },

    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("dapui").setup()
      end,
    },

    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("dap-python").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Keymaps
    vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>dc", dap.continue, {})
  end,
}
