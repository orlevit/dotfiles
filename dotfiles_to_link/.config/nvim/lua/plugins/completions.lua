return {
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" }, -- source for text in buffer
  { "hrsh7th/cmp-path" }, -- source for file system paths
  { "onsails/lspkind.nvim" }, -- vs-code like pictograms
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",  -- This will build the jsregexp dependency
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = { -- Control the popup-menu behavior
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          -- completion.zindex = 2001,
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_next_item(),
          ["<C-j>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-c>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path"   },
          { name = "buffer" },
        }),
        formatting = { -- For vs-code like pictograms in completion menu
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
      
    -- Due to Copilot, needed changes 
    -- Because of Copliot, we need to ensure that the completion menu is always on top
    -- if the completion menu is not on top , increase the  "zindex" value.
    cmp.setup({
      window = {
        completion = {
          border = "rounded",
          zindex = 20001,  -- this ensures popup is on top
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          scrolloff = 0,
          col_offset = 0,
          side_padding = 1,
        },
        documentation = {
          border = "rounded",
          zindex = 20000,  -- slightly below the menu
        },
      },
    })

    -- the first suggestion it fro the buttom
    cmp.setup({
        view = {
          docs = {
            auto_open = true,
          },
          entries = {
            follow_cursor = false,
            name = "custom",
            selection_order = "bottom_up", -- this starts selection from bottom
          },
        },
      })
    end,
  },
}
