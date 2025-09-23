return {
  "kiyoon/jupynium.nvim",
  build = "pip install --user .", -- or however you install
  config = function()
    local jupynium = require("jupynium")

    jupynium.setup({
      use_default_keybindings = false,
      textobjects = {
        use_default_keybindings = false,
      },
      -- other options...
    })

    -- 🔑 Custom keymaps inside config
    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    map("n", "<leader>js", "<Cmd>JupyniumStartAndAttachToServer<CR>", vim.tbl_extend("force", opts, { desc = "Start Jupynium" }))
    map("n", "<leader>jj", "<Cmd>JupyniumExecuteSelectedCells<CR>", vim.tbl_extend("force", opts, { desc = "Execute selected cells" }))
    map("n", "<leader>ja", "<Cmd>JupyniumExecuteAllCells<CR>", vim.tbl_extend("force", opts, { desc = "Execute all cells" }))
    map("n", "<leader>jc", "<Cmd>JupyniumClearOutputs<CR>", vim.tbl_extend("force", opts, { desc = "Clear outputs" }))
    map("n", "<leader>jr", "<Cmd>JupyniumRestartKernel<CR>", vim.tbl_extend("force", opts, { desc = "Restart kernel" }))
    map("n", "<leader>ji", "<Cmd>JupyniumInterruptKernel<CR>", vim.tbl_extend("force", opts, { desc = "Stop kernel" }))
    map("n", "<leader>jy", "<Cmd>JupyniumStartSync<CR>", vim.tbl_extend("force", opts, { desc = "Sync" }))
  end,
}
