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
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local qf_entries = {}
  
  -- Use nvim_buf_get_lines to get all buffer lines
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  -- Simple regex pattern to find function definitions
  local pattern = "^%s*def%s+([%w_]+)%s*%(.-%)%s*:"
  
  for i, line in ipairs(lines) do
    local func_name = line:match(pattern)
    if func_name then
      table.insert(qf_entries, {
        bufnr = bufnr,
        lnum = i,
        col = line:find("def") + 4, -- Position after "def "
        text = "Function: " .. func_name
      })
    end
  end
  
  -- Only show lines with functions
  if #qf_entries > 0 then
    vim.fn.setqflist(qf_entries, 'r')
    vim.cmd("botright copen")
    -- Return to previous buffer/window
    vim.api.nvim_set_current_win(win)
  else
    print("No functions found")
  end
end


vim.keymap.set("n", "<leader>qf", OpenAllPythonFunctionsInQuickfix, { desc = "Open all functions in quickfix" })
-- ###

-- ### populate quickfix list with diagnostics
function OpenDiagnosticsInQuickfix()
  local current_buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  -- Get diagnostics for current buffer
  local diagnostics = vim.diagnostic.get(current_buf)
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

  -- Only show lines with diagnostics
  if #qf_entries > 0 then
    vim.fn.setqflist(qf_entries, 'r')
    vim.cmd("botright copen")

    -- Return to previous buffer/window
    vim.api.nvim_set_current_win(win)
  else
    print("No diagnostics found")
  end
end

vim.keymap.set("n", "<leader>qd", OpenDiagnosticsInQuickfix, { desc = "Open diagnostics in quickfix" })

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

-- Function to navigate between code cells
local function goto_cell(direction)
  local pattern = "^# %%"
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local line_count = vim.api.nvim_buf_line_count(0)
  
  -- Direction: 1 for next, -1 for previous
  local step = direction > 0 and 1 or -1
  local start_line = current_line + step
  local end_line = direction > 0 and line_count or 1
  
  for line_num = start_line, end_line, step do
    local line = vim.api.nvim_buf_get_lines(0, line_num-1, line_num, false)[1]
    if line and line:match(pattern) then
      vim.api.nvim_win_set_cursor(0, {line_num, 0})
      return
    end
  end
  
  print("No " .. (direction > 0 and "next" or "previous") .. " cell found")
end

-- Set up keymaps
vim.keymap.set({'n','x'}, ']b', function() goto_cell(1) end, {desc = "Next code cell"})
vim.keymap.set({'n','x'}, '[b', function() goto_cell(-1) end, {desc = "Previous code cell"})
-- ##
