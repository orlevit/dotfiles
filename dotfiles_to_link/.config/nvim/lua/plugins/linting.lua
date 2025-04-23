return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		local pylint = lint.linters.pylint

		pylint.args = {
			"-f",
			"json",
			"--from-stdin",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
			"--disable=C0115", -- <— disable missing-module-docstring
      -- No need if there is .pylintrc file in home directory
      -- "--init-hook",
      --    -- add the buffer’s directory to sys.path
      --    string.format(
      --      "import sys; sys.path.insert(0, %q)",
      --      vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      --    ),
    }

		lint.linters_by_ft = {
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>gl", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
