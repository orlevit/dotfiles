return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
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
                -- disable the “missing module docstring” check (C0114)
                             args = { "--disable=C0114" },},
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
