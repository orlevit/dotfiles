return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.files").setup({
			windows = { preview = true, 
                  width_preview = 100 },
		})

    vim.keymap.set("n", "<leader>em", function() require("mini.files").open() end, { desc = "Open mini.files explorer" })

	end,
}
