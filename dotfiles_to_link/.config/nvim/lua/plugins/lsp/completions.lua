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
        view = {
          docs = {
            auto_open = true,
          },
          entries = {
            follow_cursor = false,
            name = "custom",
            selection_order =  "top_down", --"bottom_up", -- "top_down", -- this starts selection from top
          },
        },
        experimental = {
          ghost_text = false, -- disable ghost text to avoid conflicts
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-c>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        -- Sources for autocomplete ( Order matters!)
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path"   },
        }),
        formatting = { -- For vs-code like pictograms in completion menu
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
}
