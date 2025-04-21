return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons"},
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			diagnostics = "nvim_lsp",
			show_buffer_close_icons = false,
			-- How to render diagnostics
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local status = ""
				for e, n in pairs(diagnostics_dict) do
					status = status .. (e == "error" and n .. " " or "")
					status = status .. (e == "warning" and n .. " " or "")
				end
				return status
			end,
			-- Not showing if oil plugin installed
			custom_filter = function(buf_number, buf_numbers)
				if vim.bo[buf_number].filetype ~= "oil" then
					return true
				end
			end,
			separator_style = "slant",
			offsets = {
				{
					filetype = "NvimTree",
					text = "NvimTree",
					text_align = "left",
					separator = true,
				},
			},
		},
	},
	config = function(_, opts)
		-- Setup bufferline with the provided options
		require("bufferline").setup(opts)

		-- Define keymaps for bufferline operations
		-- Navigate between tabs
		vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
		vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })

		-- Switch places
		vim.keymap.set("n", "<leader>[t", "<cmd>-tabmove<cr>", { desc = "Move tab left" })
		vim.keymap.set("n", "<leader>]t", "<cmd>+tabmove<cr>", { desc = "Move tab right" })

		-- Pick a buffer
		vim.keymap.set("n", "gt", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })

		-- Close a buffer
		vim.keymap.set("n", "<leader>td", "<cmd>BufferLinePickClose<cr>", { desc = "Pick buffer to close" })

		-- Go to specific buffer by position
		vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", { desc = "Go to buffer 1" })
		vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", { desc = "Go to buffer 2" })
		vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", { desc = "Go to buffer 3" })
		vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", { desc = "Go to buffer 4" })
		vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", { desc = "Go to buffer 5" })

		-- -- These not working in TAB mode, only in buffer mode
		-- -- Sort buffers
		-- vim.keymap.set("n", "<leader>ts", "<cmd>BufferLineSortByDirectory<cr>", { desc = "Sort buffers by directory" })
		-- -- Switch places
		-- vim.keymap.set("n", "]t", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
		-- vim.keymap.set("n", "[t", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
	end,
}
