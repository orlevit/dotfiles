vim.g.mapleader = " "
vim.g.loaded_perl_provider = 0 -- not using perl
vim.g.loaded_ruby_provider = 0 -- not using ruby

-- Tabs & Spaces
vim.opt.tabstop = 2 -- spces for tabs
vim.opt.softtabstop = 2 -- how many  spaces inserted/removed intav/backwards
vim.opt.shiftwidth = 2 -- Spaces for tab width
vim.opt.expandtab = true --expand tab spaces
vim.opt.autoindent = true -- current indent continue to next line

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

vim.opt.cursorline = true -- highlight the current cursor line
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

vim.opt.swapfile = false -- no .swp

vim.wo.number = true
vim.wo.relativenumber = true


-- # Collapse
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99          -- Keep all folds open
-- ####
