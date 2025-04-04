return {
  "mg979/vim-visual-multi",
  branch = "master", -- important!
  lazy = false,
  init = function()
    -- Enable default mappings
    vim.g.VM_default_mappings = 1

    -- Custom mappings
    vim.g.VM_maps = {
      ["Find Under"]               = "<A-n>",
      ["Find Subword Under"]       = "<A-n>",
      ["Select All"]               = "<A-A>",
      ["Add Cursor Right"]          = "<A-Right>",
      ["Add Cursor Down"]          = "<A-Down>",
      ["Add Cursor Up"]            = "<A-Up>",

      ["Select Cursor Down"]       = "<S-Down>",
      ["Select Cursor Up"]         = "<S-Up>",
      ["Visual Cursors"]           = "<A-S-n>", -- Alt + Shift + n → rotate backward
      ["Next"]                     = "n",
      ["Previous"]                 = "N",
      ["Skip Region"]              = "q",       -- skip current and get next
      ["Remove Region"]            = "Q",       -- remove current
      ["Goto Next Region"]         = "]",       -- move to next cursor
      ["Goto Prev Region"]         = "[",       -- move to previous cursor
    }

    -- Optional behavior tweaks
    vim.g.VM_mouse_mappings = 1
    vim.g.VM_show_warnings = 0
  end
}
