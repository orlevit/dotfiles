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

-- ### populate quickfix list with all functions
function OpenAllPythonFunctionsInQuickfix()
  local ts = vim.treesitter
  local parser = ts.get_parser(0, "python")
  local tree = parser:parse()[1]
  local root = tree:root()

  local query = [[
    (function_definition name: (identifier) @name)
  ]]

  local lang = "python"
  local ok, ts_query = pcall(ts.query.parse, lang, query)
  if not ok then
    return
  end

  local qf_entries = {}
  local bufnr = vim.api.nvim_get_current_buf()

  for _, match in ts_query:iter_matches(root, bufnr) do
    for id, node in pairs(match) do
      local name = ts_query.captures[id]
      if name == "name" then
        local start_row, start_col = node:start()
        local text = vim.treesitter.get_node_text(node, bufnr)
        table.insert(qf_entries, {
          bufnr = bufnr,
          lnum = start_row + 1,
          col = start_col + 1,
          text = "Function: " .. text
        })
      end
    end
  end

  vim.fn.setqflist(qf_entries, 'r')
  vim.cmd("botright copen")
end


vim.keymap.set("n", "<leader>qf", OpenAllPythonFunctionsInQuickfix, { desc = "Open all functions in quickfix" })
-- ###

-- ### populate quickfix list with diagnostics
function OpenDiagnosticsInQuickfix()
  local diagnostics = vim.diagnostic.get(0) -- current buffer
  local qf_entries = {}

  for _, d in ipairs(diagnostics) do
    table.insert(qf_entries, {
      bufnr = d.bufnr,
      lnum = d.lnum + 1,
      col = d.col + 1,
      text = d.message,
      type = ({
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.INFO] = "I",
        [vim.diagnostic.severity.HINT] = "H",
      })[d.severity] or "E",
    })
  end

  vim.fn.setqflist(qf_entries, 'r')
  vim.cmd("botright copen")
end

vim.keymap.set("n", "<leader>qd", OpenDiagnosticsInQuickfix, { desc = "Open diagnostics in quickfix" })

-- ### populate quickfix list with search word under cursor or insert another
-- ### populate quickfix list with search word under cursor or insert another
function _G.search_and_populate_quickfix()
  -- Store the current buffer number for returning later
  local original_bufnr = vim.api.nvim_get_current_buf()
  local original_winnr = vim.api.nvim_get_current_win()
  
  -- Get the word under cursor first for the prompt
  local current_word = vim.fn.expand("<cword>")
  local prompt_text = "Search Word"
  
  -- Include the word in the prompt if one exists
  if current_word ~= "" then
    prompt_text = prompt_text .. " (default: \"" .. current_word .. "\")"
  end
  prompt_text = prompt_text .. ": "
  
  -- Prompt the user with the word under cursor shown
  local input = vim.fn.input(prompt_text)
  local word
  if input == "" then
    if current_word == "" then
      return
    end
    word = current_word
  else
    word = input
  end
  
  -- Escape special regex characters in the word.
  local function escape(str)
    return str:gsub("([^%w])", "\\%1")
  end
  
  -- Build the whole-word search pattern using \< and \>.
  local pattern = "\\<" .. escape(word) .. "\\>"
  
  -- Use vimgrep to search in the current file (expand("%") is the current file).
  vim.cmd("vimgrep /" .. pattern .. "/ " .. vim.fn.expand("%"))
  
  -- Open the quickfix window
  vim.cmd("copen")
  
  -- Return to the original buffer
  vim.api.nvim_set_current_win(original_winnr)
  
  -- Notify the user with the search term and the number of matches.
  local qflist = vim.fn.getqflist()
  vim.notify("Searched pattern: \"" .. word .. "\" (" .. tostring(#qflist) .. " matches)", vim.log.levels.INFO)
end

-- Map the function to a key (here <leader>sw).
vim.api.nvim_set_keymap("n", "<leader>qw", "<cmd>lua search_and_populate_quickfix()<CR>", { noremap = true, silent = true })
-- ###

-- Select all lines in file
function SelectAll()
  vim.cmd('normal! ggVG')
end

vim.keymap.set('n', '<C-a>', SelectAll, { noremap = true, silent = true })
-- ##
