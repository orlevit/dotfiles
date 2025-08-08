return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
    'mfussenegger/nvim-dap-python',
    'nvim-telescope/telescope-dap.nvim',   -- telescope extension for dap
  },
  keys = {
    { '<leader>dc', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<leader>di', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<leader>do', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<leader>dO', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Debug: Set Breakpoint' },
    { '<leader>dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = 'Debug: Set Log Point' },
    { '<leader>dv', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
    { '<leader>da', ':Telescope dap list_breakpoints<CR>', desc = 'Debug: List Breakpoints (Telescope)', noremap = true, silent = true },
    { '<leader>dq', function() require('dap').terminate() end, desc = 'Debug: Terminate' },
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
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    local dap_python = require('dap-python')
    local notify = vim.notify
    -- Wrap vim.notify to schedule calls and avoid E565 errors
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
        program = vim.fn.getcwd() .. '/manage.py',
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

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    vim.schedule(function()
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🔵', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '🟢', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '➡️', texthl = '', linehl = '', numhl = '' })
    end)
  end,
}
