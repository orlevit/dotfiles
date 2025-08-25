vim.g.mapleader = " "
vim.g.loaded_perl_provider = 0 -- not using perl
vim.g.loaded_ruby_provider = 0 -- not using ruby
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" } --Sets root directory detection logic (used for LSP, file tree, formatting, etc.)

-- Tabs & Spaces
vim.opt.tabstop = 2 -- spces for tabs
vim.opt.softtabstop = 2 -- how many  spaces inserted/removed intav/backwards
vim.opt.shiftwidth = 2 -- Spaces for tab width
vim.opt.expandtab = true --expand tab spaces
vim.opt.autoindent = true -- current indent continue to next line

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
vim.opt.wildmode = "longest:full,full" -- First completion inserts longest common match and previews full match

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

vim.opt.swapfile = false -- no .swp


-- # Collapse
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99          -- Keep all folds open
-- ####

-- Readability
vim.opt.conceallevel = 2 --Cleaner look when reading markdown
vim.wo.number = true
vim.wo.relativenumber = true
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#FFFFFF" }) -- brighter white relative number lines (since plugin cappucine is used, it override this one)
vim.opt.linebreak = true -- Breaks long lines at word boundaries rather than in the middle of words.
vim.opt.list = true --  Shows hidden characters like spaces and tabs visually.
vim.opt.pumblend = 10 --Adds transparency to popup menus.
vim.opt.cursorline = true -- highlight the current cursor line
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift

--Visability
vim.opt.showmode = false --Disables showing mode (like -- INSERT --) since statusline shows it.
vim.opt.timeoutlen = 300 --Faster reaction time for keymaps (like which-key).


-- Miscellaneous
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } --What been save in session
vim.g.root_lsp_ignore = { "copilot" }

-- Add English spelling check ( go with [s/]s )
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
