-- [null-ls] is a Neovim plugin that allows you to use external tools (formatters, linters, etc.) as if they were LSP servers. It is useful for integrating tools that don’t have their own LSP server.
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.black,
        --null_ls.builtins.diagnostics.erb_lint,
        --null_ls.builtins.diagnostics.rubocop,
        --null_ls.builtins.formatting.rubocop,
        --null_ls.builtins.diagnostics.mypy,
        --null_ls.builtins.diagnostics.pylint,
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,

}
