return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  opts = {
    terminal = {
      provider = "snacks",
      snacks_win_opts = {
        position = "bottom",
        height = 0.35,
      },
    },
  },
  keys = {
    { "<leader>kk", "<cmd>ClaudeCode<cr>",            desc = "ClaudeCode: Toggle terminal" },
    { "<leader>kf", "<cmd>ClaudeCodeFocus<cr>",       desc = "ClaudeCode: Focus terminal" },
    { "<leader>km", "<cmd>ClaudeCodeSelectModel<cr>", desc = "ClaudeCode: Select model" },
    { "<leader>kr", "<cmd>ClaudeCodeSend<cr>",        desc = "ClaudeCode: Send selection", mode = "v" },
    { "<leader>ka", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "ClaudeCode: Accept diff" },
    { "<leader>kd", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "ClaudeCode: Deny diff" },
  },
}
