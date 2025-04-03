vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', function()
  vim.o.hlsearch = not vim.o.hlsearch
end, { desc = "Toggle search highlighting" })

vim.wo.number = true
vim.wo.relativenumber = true

-- ### Tabs
-- NORMAL MODE
vim.keymap.set("n", "<Tab>", ">>", { noremap = true, silent = true })      -- indent line
vim.keymap.set("n", "<S-Tab>", "<<", { noremap = true, silent = true })    -- unindent line

-- VISUAL MODE
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })     -- indent and reselect
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })   -- unindent and reselect
-- ###

-- ### Remap jump 
vim.keymap.set("n", "<A-o>", "<C-o>", { noremap = true, silent = true, desc = "Jump back in jump list" })
vim.keymap.set("n", "<A-i>", "<C-i>", { noremap = true, silent = true, desc = "Jump forward in jump list" })
-- ###

-- Retain normal visual mode as tree-sitter may chnage it
vim.keymap.set("n", "v", "v", { noremap = true })
vim.keymap.set("n", "V", "V", { noremap = true })
vim.keymap.set("n", "<C-v>", "<C-v>", { noremap = true })

-- ### Quickfix roundabout & shortcuts 
vim.keymap.set('n', '[q', function()
  local current_index = vim.fn.getqflist({idx = 0}).idx
  local qflist_length = #vim.fn.getqflist()

  if qflist_length == 0 then
    return
  elseif current_index <= 1 then
    vim.cmd('clast')  -- Wrap to the end if at the beginning
  else
    vim.cmd('cprevious')
  end
end, { silent = true })

vim.keymap.set('n', ']q', function()
  local current_index = vim.fn.getqflist({idx = 0}).idx
  local qflist_length = #vim.fn.getqflist()
  
  if qflist_length == 0 then
    return
  elseif current_index >= qflist_length then
    vim.cmd('cfirst')  -- Wrap to the beginning if at the end
  else
    vim.cmd('cnext')
  end
end, { silent = true })
-- ####

-- # Collapse
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- ####
--
-- # treminal exit
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
-- ###
