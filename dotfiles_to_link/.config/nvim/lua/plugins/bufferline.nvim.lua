return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			show_buffer_close_icons = false,

			-- How to render diagnostics
      -- only show for the current buffer in this tab
      diagnostics_indicator = function(_, _, _, context)
        if not context.buffer:current() then
          return ""
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
        local warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })

        local status = ""
        if errors > 0 then
          status = status .. errors .. " "
        end
        if warnings > 0 then
          status = status .. warnings .. " "
        end

        return status
      end,

			-- Not showing if oil plugin installed
      custom_filter = function(buf_number, _)
            local ft = vim.bo[buf_number].filetype
            local name = vim.fn.bufname(buf_number)
            
            -- Exclude NvimTree, Oil, and Quickfix buffers
            local exclude_filetypes = { "NvimTree", "oil", "qf" }
            if vim.tbl_contains(exclude_filetypes, ft) then
                return false
            end

            -- Exclude unnamed buffers (like [No Name])
            if name == "" then
                return false
            end

            return true
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
		vim.keymap.set("n", "<C-S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
		vim.keymap.set("n", "<C-S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })

		-- Switch places
		vim.keymap.set("n", "<leader>[t", "<cmd>-tabmove<cr>", { desc = "Move tab left" })
		vim.keymap.set("n", "<leader>]t", "<cmd>+tabmove<cr>", { desc = "Move tab right" })

		-- Pick a buffer
		vim.keymap.set("n", "<leader>tg", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })

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
