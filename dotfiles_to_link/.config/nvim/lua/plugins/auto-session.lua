return {
  'rmagatti/auto-session',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  
  keys = {
    -- These are just mapping triggers, not the actual mapping functions
    { '<leader>wr', desc = 'Restore Session' },
    { '<leader>ws', desc = 'Save Session' },
    { '<leader>wf', desc = 'Find Sessions' },
  },

  config = function()
    require('auto-session').setup({
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath('data') .. '/sessions/',
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/', '/tmp', "~/Documents", "~/Desktop/" },
      auto_session_use_git_branch = false,
      bypass_session_save_file_types = { 'alpha', 'dashboard' },
      
      -- Set up session lens configuration
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
        buftypes_to_ignore = {}, -- list of buffer types that should not be deleted from current session
      },
    })

    -- Load the telescope extension AFTER auto-session is setup
    require('telescope').load_extension('session-lens')

    -- Set up keymaps after everything is loaded
    vim.keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = 'Restore session for cwd' })
    vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = 'Save session for auto session root dir' })
    
    -- Use the Telescope command directly instead of the Lua function
    vim.keymap.set('n', '<leader>wf', '<cmd>Telescope session-lens search_session<CR>', { desc = 'Find sessions' })
  end,
}
