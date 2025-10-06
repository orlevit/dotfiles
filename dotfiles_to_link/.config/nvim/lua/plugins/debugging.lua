return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
    'mfussenegger/nvim-dap-python',
    'nvim-telescope/telescope-dap.nvim',   -- telescope extension for dap
    'theHamsta/nvim-dap-virtual-text',     -- inline variable values
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<S-F11>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<F9>', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<C-F9>', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Debug: Set Breakpoint' },
    { '<C-S-F9>', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = 'Debug: Set Log Point' },
    { '<F8>', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
    { '<F7>', ':Telescope dap list_breakpoints<CR>', desc = 'Debug: List Breakpoints (Telescope)', noremap = true, silent = true },
    { '<S-F5>', function() require('dap').terminate() end, desc = 'Debug: Terminate' },
    {'<F4>',  -- Find current line
      function()
        local session = require('dap').session()
        if session then
          local frame = session.current_frame
          if frame and frame.line and frame.source and frame.source.path then
            vim.cmd('edit ' .. frame.source.path)
            vim.fn.cursor(frame.line, 1)
          else
            vim.notify("Current frame not available", vim.log.levels.WARN)
          end
        else
          vim.notify("No active debug session", vim.log.levels.WARN)
        end
      end,
      desc = 'Debug: Go to current line',
    },
    {
      '<leader>df',
      function()
        local configs = require('dap').configurations.python
        for _, cfg in ipairs(configs) do
          if cfg.name == 'Flask' then
            require('dap').run(cfg)
            return
          end
        end
        print('Flask debug configuration not found')
      end,
      desc = 'Debug: Launch Flask',
    },
    -- Toggle virtual text on/off
    {
      '<leader>dv',
      function()
        require('nvim-dap-virtual-text').toggle()
      end,
      desc = 'Debug: Toggle Virtual Text',
    },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    local dap_python = require('dap-python')
    local dap_virtual_text = require('nvim-dap-virtual-text')
    local notify = vim.notify

    -- Wrap vim.notify to avoid E565 errors
    vim.notify = vim.schedule_wrap(function(...)
      notify(...)
    end)

    local function detect_python()
      local venv = os.getenv("VIRTUAL_ENV")
      if venv then
        return venv .. "/bin/python"
      end
      return "python3"
    end

    dap_python.setup(detect_python())

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = detect_python(),
      },
      {
        type = 'python',
        request = 'attach',
        name = 'Attach remote',
        host = function() return vim.fn.input('Host: ', '127.0.0.1') end,
        port = function() return tonumber(vim.fn.input('Port: ', '5678')) end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Django',
        program = vim.fn.getcwd() .. '/src/manage.py',
        args = { 'runserver', '--noreload' },
        django = true,
        pythonPath = detect_python(),
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Flask',
        module = 'flask',
        args = { 'run', '--no-debugger', '--no-reload' },
        env = {
          FLASK_APP = vim.fn.getcwd() .. '/app.py',
          FLASK_ENV = 'development',
          FLASK_DEBUG = '0',
        },
        pythonPath = detect_python(),
      },
    }

    require('mason-nvim-dap').setup({
      automatic_installation = true,
      ensure_installed = { 'debugpy' },
    })

    dapui.setup({
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    })

    -- Enhanced virtual text configuration
    dap_virtual_text.setup({
      enabled = true,                        -- enable this plugin (the default)
      enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle
      highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true,               -- show stop reason when stopped for exceptions
      commented = false,                     -- prefix virtual text with comment string
      only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
      all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
      clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
      
      --- A callback that determines how a variable is displayed or whether it should be omitted
      --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
      --- @param buf number
      --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
      --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
      --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
      --- @return string|nil A text how the variable should be displayed or nil, if this variable shouldn't be displayed
      display_callback = function(variable, buf, stackframe, node, options)
        -- Skip internal/hidden variables (starting with __)
        if variable.name:match('^__') then
          return nil  -- Don't display at all
        end
        
        -- Skip very long values
        if variable.value and string.len(variable.value) > 150 then
          return variable.name .. ' = <' .. (variable.type or 'long value') .. '>'
        end
        
        -- Clean format: just name = value
        return variable.name .. ' = ' .. variable.value
      end,
      
      -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
      virt_text_pos = 'eol',
      
      -- experimental features:
      all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    })

    -- -- Set up listeners for dapui
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated['dapui_config'] = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited['dapui_config'] = function()
    --   dapui.close()
    -- end

    -- Set up virtual text refresh on debug events
    dap.listeners.after.event_stopped['nvim-dap-virtual-text'] = function()
      require('nvim-dap-virtual-text').refresh()
    end
    -- Captures error messages from stderr and displays them as Neovim
    dap.listeners.after.event_output['notify_output'] = function(session, body)
    if body.category == 'stderr' then
        vim.notify(body.output, vim.log.levels.ERROR)
      end
    end

    -- Configure DAP REPL completion keybindings
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dap-repl',
      callback = function(args)
        -- Enable completion navigation with Ctrl+j/k
        vim.keymap.set('i', '<C-j>', '<C-n>', { buffer = args.buf, desc = 'Next completion' })
        vim.keymap.set('i', '<C-k>', '<C-p>', { buffer = args.buf, desc = 'Previous completion' })
        
      end,
    })

    -- Define custom highlight groups for better visibility
    vim.schedule(function()
      -- DAP signs
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🔵', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '🟢', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '➡️', texthl = '', linehl = '', numhl = '' })
      
      -- Virtual text highlights - orange color
      vim.api.nvim_set_hl(0, 'NvimDapVirtualText', { fg = '#FF8C00', italic = true })
      vim.api.nvim_set_hl(0, 'NvimDapVirtualTextChanged', { fg = '#FF6347', italic = true, bold = true })
    end)
  end,
}
