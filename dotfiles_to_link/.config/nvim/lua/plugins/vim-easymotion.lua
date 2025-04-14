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
      vim.keymap.set('n', '<Leader><Leader>f', '<Plug>(easymotion-overwin-f)')
      vim.keymap.set('n', '<Leader><Leader>s', '<Plug>(easymotion-overwin-f2)')
      vim.keymap.set('n', '<Leader><Leader>w', '<Plug>(easymotion-overwin-w)')

      -- Additional useful motions
      vim.keymap.set('n', '<Leader><Leader>b', '<Plug>(easymotion-b)') -- Beginning of word backward
      vim.keymap.set('n', '<Leader><Leader>e', '<Plug>(easymotion-e)') -- End of word
      vim.keymap.set('n', '<Leader><Leader>j', '<Plug>(easymotion-j)') -- Line downward
      vim.keymap.set('n', '<Leader><Leader>k', '<Plug>(easymotion-k)') -- Line upward
      vim.keymap.set('n', '<Leader><Leader>n', '<Plug>(easymotion-n)') -- Jump to next search match
      vim.keymap.set('n', '<Leader><Leader>N', '<Plug>(easymotion-N)') -- Jump to previous search match

      -- Line motions (beginning of line)
      vim.keymap.set('n', '<Leader><Leader>L', '<Plug>(easymotion-bd-jk)')

      -- Repeat last motion
      vim.keymap.set('n', '<Leader><Leader>.', '<Plug>(easymotion-repeat)')
    end,
    -- Add lazy-loading
    event = "VeryLazy",
  }
}
