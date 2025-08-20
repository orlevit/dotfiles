return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.files").setup({
      mappings = {
        go_in = 'L',       -- Make plain `L` just open without closing
        go_in_plus = 'l',  -- Make `l` open AND close explorer
      },
			windows = { preview = true, 
                  width_preview = 100 },
		  }
    )

    vim.keymap.set("n", "<leader>em", function() require("mini.files").open() end, { desc = "Open mini.files explorer" })

	end,
}
