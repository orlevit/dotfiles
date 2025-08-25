return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				file_ignore_patterns = { ".*_env/.*" }, -- ignore any path containing a folder that ends with _env
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-x>"] = actions.delete_buffer,
					},
					n = {
						["<C-x>"] = actions.delete_buffer, -- close buffer in normal mode
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("todo-comments")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		local opts = {
			layout_strategy = "vertical",
			prompt_position = "bottom",
			layout_config = {
				vertical = {
					preview_height = 0.6, -- 60% of the window for the preview
					mirror = false, -- preview on top, results below
				},
			},
		}
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>fp", function()
			builtin.find_files(opts)
		end, { desc = "Telescope ▶ Preview‑top vertical find_files" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fg", function()
			builtin.live_grep(opts)
		end, { desc = "Find string in cwd" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>fc", function()
			builtin.grep_string(opts)
		end, { desc = "Find string under cursor in cwd" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find among open buffers" })
		vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find marks" })
		vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
		vim.keymap.set("n", "<leader>gC", builtin.git_bcommits, { desc = "Git Buffer Commits" }) -- current file only
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
		vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Git Stash" }) -- You may need a custom diff if you want hunks
		vim.keymap.set("n", "<leader>fy", function()
			local last_yank = vim.fn.getreg('"')
			if last_yank == "" then
				print("No yanked text found!")
				return
			end
			builtin.live_grep({ default_text = last_yank })
		end, { desc = "Search last yanked text in project" })
	end,
}
