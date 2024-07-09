local lazypath = "/home/or/dev/dotfiles/Additional_packages/lazy.vim"

------ Nvim configurations -----
vim.g.mapleader = "," -- Set the leader key to comma
vim.opt.mouse = "a"   -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4      -- number of visual spaces per TAB
vim.opt.softtabstop = 4  -- number of spacesin tab when editing
vim.opt.shiftwidth = 4   -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true         -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true     -- highlight cursor line underneath the cursor horizontally

-- Better window navigation

-- define common options
local opts = {
    noremap = true, -- non-recursive
    silent = true,  -- do not show message
}

vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
----------------------------------

------- Install Lazy ------
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "catppuccin/nvim",                        name = "catppuccin",                             priority = 1000 },
        { "nvim-lualine/lualine.nvim",              dependencies = { "nvim-tree/nvim-web-devicons" } },
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("nvim-tree").setup({})
            end,
        },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "neovim/nvim-lspconfig" },
        { "nvimtools/none-ls.nvim" },
        { "hrsh7th/nvim-cmp" },
        { "L3MON4D3/LuaSnip", dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets"}},
        {"hrsh7th/cmp-nvim-lsp"},
        checker = { enabled = true },
    },
})

-------------------------------------------------
-- Add parppuccin coloescheme
-------------------------------------------------
require("catppuccin").setup()
vim.cmd([[colorscheme catppuccin]])

-------------------------------------------------
-- telescope recommanded bindings
-------------------------------------------------
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Add extention to the telescope - UI select plugin
require("telescope").setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({
                -- even more opts
            }),
        },
    },
})

require("telescope").load_extension("ui-select")
-------------------------------------------------
-- Set lualine
-------------------------------------------------
require("lualine").setup({ options = { theme = "dracula" } })

-------------------------------------------------
-- Set nvim-tree
-------------------------------------------------
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-web-devicons").setup({ default = true })
require("nvim-tree").setup({})

-- Toggle Tree
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Close nvim-tree when it's the only window left
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
    callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})
        if
            layout[1] == "leaf"
            and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
            and layout[3] == nil
        then
            vim.cmd("quit")
        end
    end,
})

-------------------------------------------------
-- Set LSP (mason,mason-lsp,nvim lsp)
-------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "pylsp" } })

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- For each language . nvim lsp
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({ capabilities = capabilities, settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
lspconfig.pylsp.setup({capabilities = capabilities})

-- Attach function
local function lsp_on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
end

lspconfig.pylsp.setup({ { on_attach = lsp_on_attach } })
lspconfig.lua_ls.setup({ on_attach = lsp_on_attach, settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

-------------------------------------------------
-- None-ls formatters nad linters(Lua, Python)
-- Remarks: Do not forget to install those with :Mason
-------------------------------------------------
local null_ls = require("null-ls")

-- Attach function
local function none_ls_on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>df", vim.lsp.buf.format, bufopts)
end

null_ls.setup({
    on_attach = none_ls_on_attach,
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.formatting.stylua,
    },
})

-------------------------------------------------
-- Automcomplete & snippet (Nvim-cmp,Luasnip,cmp-nvim-lsp
-------------------------------------------------
local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
    })
})

