return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent"}
      end,
      open_fold_hl_timeout = 0,
      close_fold_kinds_for_ft = {},
    },
    init = function()
      vim.o.foldcolumn = "0" -- Hide fold column
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function(_, opts)
      require("ufo").setup(opts)
      
      -- Remove fold line highlighting (must be after setup)
      vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { bg = "NONE" })
      
      -- Keymaps
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Fold less" })
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Fold more" })
      vim.keymap.set("n", "zp", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold or hover" })
    end,
  },
  
  -- Update your existing nvim-lspconfig to add UFO capabilities
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
    },
    opts = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      return {
        capabilities = capabilities,
      }
    end,
  },
}
