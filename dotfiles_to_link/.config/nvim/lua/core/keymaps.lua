
-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Highlight toggle
vim.keymap.set('n', '<leader>h', function()
  vim.o.hlsearch = not vim.o.hlsearch
end, { desc = "Toggle search highlighting" })

-- ### Tabs
-- NORMAL MODE
vim.keymap.set("n", "<Tab>", ">>", { noremap = true, silent = true })      -- indent line
vim.keymap.set("n", "<S-Tab>", "<<", { noremap = true, silent = true })    -- unindent line

-- INSERT MODE
vim.keymap.set("i", "<Tab>", "<Esc>>>i", { noremap = true, silent = true })
vim.keymap.set("i", "<S-Tab>", "<Esc><<i", { noremap = true, silent = true })

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

-- # treminal exit
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true }, { desc = "Exit terminal mode" })
-- ###
--
-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Insert black lines
vim.keymap.set("n", "<leader>o", "o<Esc>", { desc = "Insert blank line below (stay in normal mode)" })
vim.keymap.set("n", "<leader>O", "O<Esc>", { desc = "Insert blank line above (stay in normal mode)" })

-- The direction of n and N depends on whether / or ? was used for searching forward or backward respectively.
-- This is pretty confusing to me.
-- If you want n to always search forward and N backward, use this:
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
