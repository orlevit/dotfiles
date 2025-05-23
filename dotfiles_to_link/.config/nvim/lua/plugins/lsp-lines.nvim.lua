return {
    "maan2003/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      -- Disable virtual_text since it's redundant due to lsp_lines
      vim.diagnostic.config({ virtual_text = false, })

      vim.keymap.set("n", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end
}

