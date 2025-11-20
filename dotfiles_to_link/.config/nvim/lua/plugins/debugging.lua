return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
    'mfussenegger/nvim-dap-python',
    'nvim-telescope/telescope-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',
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
    {'<F4>',
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

    local function detect_debugpy()
      local venv = os.getenv("VIRTUAL_ENV")
      if venv then
        return venv .. "/bin/python"
      end
      return "python3"
    end

    -- Setup dap-python with the correct interpreter
    local python_path = detect_python()
    dap_python.setup(python_path)

    -- Ensure debugpy is installed in the virtual environment
    require('mason-nvim-dap').setup({
      automatic_installation = true,
      ensure_installed = { 'debugpy' },
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
        debugpy = function(config)
          config.python = python_path
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    })

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = python_path,
      },
      {
        type = 'python',
        request = 'attach',
        name = 'Attach remote',
        host = function() return vim.fn.input('Host: ', '127.0.0.1') end,
        port = function() return tonumber(vim.fn.input('Port: ', '5678')) end,
        pythonPath = python_path,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Django',
        program = vim.fn.getcwd() .. '/src/manage.py',
        args = { 'runserver', '--noreload' },
        django = true,
        pythonPath = python_path,
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
        pythonPath = python_path,
      },
    }

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

    dap_virtual_text.setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      
      display_callback = function(variable, buf, stackframe, node, options)
        if variable.name:match('^__') then
          return nil
        end
        
        if variable.value and string.len(variable.value) > 150 then
          return variable.name .. ' = <' .. (variable.type or 'long value') .. '>'
        end
        
        return variable.name .. ' = ' .. variable.value
      end,
      
      virt_text_pos = 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil
    })

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    dap.listeners.after.event_stopped['nvim-dap-virtual-text'] = function()
      require('nvim-dap-virtual-text').refresh()
    end

    dap.listeners.after.event_output['notify_output'] = function(session, body)
      if body.category == 'stderr' then
        vim.notify(body.output, vim.log.levels.ERROR)
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dap-repl',
      callback = function(args)
        vim.keymap.set('i', '<C-j>', '<C-n>', { buffer = args.buf, desc = 'Next completion' })
        vim.keymap.set('i', '<C-k>', '<C-p>', { buffer = args.buf, desc = 'Previous completion' })
      end,
    })

    vim.schedule(function()
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🔵', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '🟢', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '➡️', texthl = '', linehl = '', numhl = '' })
      
      vim.api.nvim_set_hl(0, 'NvimDapVirtualText', { fg = '#FF8C00', italic = true })
      vim.api.nvim_set_hl(0, 'NvimDapVirtualTextChanged', { fg = '#FF6347', italic = true, bold = true })
    end)
  end,
}
