return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {
		focus = true,
		-- Define custom modes that exclude _env directories
		modes = {
			diagnostics = {
				mode = "diagnostics",
				filter = function(items)
					return vim.tbl_filter(function(item)
						local filename = item.filename or ""
						return not filename:match("[^/\\]*_env[/\\]")
					end, items)
				end,
			},
			todo = {
				mode = "todo", 
				filter = function(items)
					return vim.tbl_filter(function(item)
						local filename = item.filename or ""
						return not filename:match("[^/\\]*_env[/\\]")
					end, items)
				end,
			},
		},
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Open trouble document diagnostics",
		},
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
	},
}
