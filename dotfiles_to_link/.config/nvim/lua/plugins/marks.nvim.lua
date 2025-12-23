return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {
    -- Enable default mappings (true by default)
    default_mappings = true,
    
    -- Optional: Show builtin marks
    builtin_marks = { ".", "<", ">", "^" },
    
    -- Optional: Customize specific mappings (all the defaults are already these)
    mappings = {
      set = "m",              -- Set mark at cursor (mx for mark x)
      set_next = "m,",        -- Set next available lowercase mark
      toggle = "m;",          -- Toggle next available mark
      delete = "dm",          -- Delete mark (dmx for mark x)
      delete_line = "dm-",    -- Delete all marks on current line
      delete_buf = "dm<space>", -- Delete all marks in current buffer
      next = "m]",            -- Move to next mark
      prev = "m[",            -- Move to previous mark
      preview = "m:",         -- Preview mark
      
      -- Bookmark mappings
      set_bookmark0 = "m0",
      set_bookmark1 = "m1",
      set_bookmark2 = "m2",
      set_bookmark3 = "m3",
      set_bookmark4 = "m4",
      set_bookmark5 = "m5",
      set_bookmark6 = "m6",
      set_bookmark7 = "m7",
      set_bookmark8 = "m8",
      set_bookmark9 = "m9",
      
      delete_bookmark = "dm=",
      delete_bookmark0 = "dm0",
      delete_bookmark1 = "dm1",
      delete_bookmark2 = "dm2",
      delete_bookmark3 = "dm3",
      delete_bookmark4 = "dm4",
      delete_bookmark5 = "dm5",
      delete_bookmark6 = "dm6",
      delete_bookmark7 = "dm7",
      delete_bookmark8 = "dm8",
      delete_bookmark9 = "dm9",
      
      next_bookmark = "m}",
      prev_bookmark = "m{",
    }
  },
}
