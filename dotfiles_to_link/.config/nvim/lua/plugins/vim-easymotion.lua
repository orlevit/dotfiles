return {
  {
    "easymotion/vim-easymotion",
    config = function()

      -- Basic settings
      vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings
      vim.g.EasyMotion_smartcase = 1 -- Enable smartcase
      vim.g.EasyMotion_startofline = 0 -- Keep cursor column when JK motion
      vim.g.EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj' -- Keys used for labels
      vim.g.EasyMotion_use_upper = 0 -- Don't use uppercase for labels

      -- Enhanced visuals
      vim.g.EasyMotion_add_search_history = 0 -- Don't add to search history
      vim.g.EasyMotion_off_screen_search = 0 -- Don't show off-screen targets
      vim.g.EasyMotion_inc_highlight = 1 -- Incrementally highlight

      -- Basic motions
      vim.keymap.set('n', '<Leader><Leader>f', '<Plug>(easymotion-overwin-f)', { desc = "Jump to character (across windows)" })
      vim.keymap.set('n', '<Leader><Leader>s', '<Plug>(easymotion-overwin-f2)', { desc = "Jump to 2-character sequence (across windows)" })
      vim.keymap.set('n', '<Leader><Leader>w', '<Plug>(easymotion-overwin-w)', { desc = "Jump to word beginning (across windows)" })

      -- Additional useful motions
      vim.keymap.set('n', '<Leader><Leader>b', '<Plug>(easymotion-b)', { desc = "Jump to beginning of word backward" })
      vim.keymap.set('n', '<Leader><Leader>e', '<Plug>(easymotion-e)', { desc = "Jump to end of word" })
      vim.keymap.set('n', '<Leader><Leader>j', '<Plug>(easymotion-j)', { desc = "Jump to line downward" })
      vim.keymap.set('n', '<Leader><Leader>k', '<Plug>(easymotion-k)', { desc = "Jump to line upward" })
      vim.keymap.set('n', '<Leader><Leader>n', '<Plug>(easymotion-n)', { desc = "Jump to next search match" })
      vim.keymap.set('n', '<Leader><Leader>N', '<Plug>(easymotion-N)', { desc = "Jump to previous search match" })

      -- Line motions (beginning of line)
      vim.keymap.set('n', '<Leader><Leader>L', '<Plug>(easymotion-bd-jk)', { desc = "Bidirectional jump to line" })

      -- Repeat last motion
      vim.keymap.set('n', '<Leader><Leader>.', '<Plug>(easymotion-repeat)', { desc = "Repeat last EasyMotion jump" })
    end,
    -- Add lazy-loading
    event = "VeryLazy",
  }
}
