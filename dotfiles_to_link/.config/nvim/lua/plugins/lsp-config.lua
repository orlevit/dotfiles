return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "-",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true }, -- Import change automaticlly when file names are change
      { "folke/neodev.nvim", opts = {} } -- Additional Lua functionallity
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      local venv = os.getenv("VIRTUAL_ENV")
      local pylsp_cmd = venv
        and { venv .. "/bin/python", "-m", "pylsp" }
        or { "pylsp" }
      lspconfig.ts_ls.setup({
        capabilities = capabilities
      })
      lspconfig.solargraph.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({
        capabilities = capabilities
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
           Lua = {
               diagnostics = {
               -- Get the language server to recognize the `vim` global
               globals = {
                 'vim',
                 'require'
           }}}}})
      -- lspconfig.pyright.setup({
      --   capabilities = capabilities,
      --   filetype={"python"}
      -- })
      lspconfig.pylsp.setup({
        cmd = pylsp_cmd,
        capabilities = capabilities,
        filetypes    = { "python" },
        settings = {
          pylsp = {
            plugins = {
              pyflakes   = { enabled = true },   -- basic error checking
              pyls_mypy  = { enabled = false },  -- turn off mypy plugin if present
              pylint     = { enabled = true,
                -- disable the “missing module docstring” check (C0115)
                             args = { "--disable=C0115" },},
              jedi_hover = { enabled = true },   -- enable hover provider
            }
          }
        }
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
