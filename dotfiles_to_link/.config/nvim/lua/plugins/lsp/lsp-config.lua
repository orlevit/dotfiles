return {
	{
		"williamboman/mason.nvim",
		dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
		lazy = false,
		config = function()
			require("mason").setup({
				PATH = "append",
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "-",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"html",
				"lua_ls",
				"ts_ls",
				"cssls",
				"tailwindcss",
				"emmet_ls",
				"eslint",
				"pylsp", -- Use pylsp instead of pyright
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true }, -- Import change automatically when file names are changed
			{ "folke/neodev.nvim", opts = {} }, -- Additional Lua functionality
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
				},
			})

			-- Function to get virtual environment paths
			local function get_python_venv()
				-- First check if VIRTUAL_ENV is set
				local venv = os.getenv("VIRTUAL_ENV")
				if venv then
					return {
						python = venv .. "/bin/python",
						venv_path = venv,
					}
				end

				-- Check for virtual environment in current project
				local cwd = vim.fn.getcwd()
				local common_venv_names = { "venv", ".venv", "env", ".env", "bridgit_env" }
				
				for _, name in ipairs(common_venv_names) do
					local venv_path = cwd .. "/" .. name
					local python_path = venv_path .. "/bin/python"
					if vim.fn.executable(python_path) == 1 then
						return {
							python = python_path,
							venv_path = venv_path,
						}
					end
				end

				-- Fallback to system python
				return {
					python = "python3",
					venv_path = nil,
				}
			end

			-- Get Python environment
			local python_env = get_python_venv()

			-- Use the setup only when LSP is attached to buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function()
					-- set keybinds
					vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references in Telescope" })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show LSP references in Quickfix" })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Show LSP definitions" })
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations" })
					vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Show LSP type definitions" })
					vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions" })
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
					vim.keymap.set("n", "<leader>Db", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
					vim.keymap.set("n", "<leader>Dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
					vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Go to previous diagnostic" })
					vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Go to next diagnostic" })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" })
					vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })
				end,
			})

			-- Lua LSP Configuration
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "require" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- Python LSP Configuration using pylsp
			lspconfig.pylsp.setup({
				cmd = { python_env.python, "-m", "pylsp" },
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							-- Disable pycodestyle (formatting/linting)
							pycodestyle = { 
								enabled = false,
								ignore = {'W391'},
								maxLineLength = 100,
							},
							-- Enable pyflakes (error detection)
							-- pyflakes = { 
							-- 	enabled = true,
							-- },
							-- Disable mccabe (complexity checking)
							mccabe = { 
								enabled = false,
							},
							-- Disable pylint (we'll use pyflakes instead)
							pylint = { 
								enabled = false,
							},
							-- Enable rope for refactoring
							rope_autoimport = { 
								enabled = true,
								completions = { enabled = true },
								code_actions = { enabled = true },
							},
							rope_completion = {
								enabled = true,
							},
							-- Jedi settings for completions and definitions
							jedi_completion = {
								enabled = true,
								include_params = true,
								include_class_objects = true,
								fuzzy = true,
							},
							jedi_definition = {
								enabled = true,
								follow_imports = true,
								follow_builtin_imports = true,
							},
							jedi_hover = {
								enabled = true,
							},
							jedi_references = {
								enabled = true,
							},
							jedi_signature_help = {
								enabled = true,
							},
							jedi_symbols = {
								enabled = true,
								all_scopes = true,
								include_import_symbols = true,
							},
							-- Disable yapf formatter (use black instead)
							yapf = {
								enabled = false,
							},
							-- Disable autopep8 formatter
							autopep8 = {
								enabled = false,
							},
						},
					},
				},
				on_init = function(client)
					local root_dir = client.config.root_dir
					print("pylsp initialized for:", root_dir)
					print("Using Python:", python_env.python)
					print("Virtual environment:", python_env.venv_path or "None")
					
					-- Set PYTHONPATH to include project root and virtual environment
					if python_env.venv_path then
						local python_version = vim.fn.system(python_env.python .. " --version"):match("Python (%d+%.%d+)")
						if python_version then
							local site_packages = python_env.venv_path .. "/lib/python" .. python_version .. "/site-packages"
							local current_pythonpath = vim.env.PYTHONPATH or ""
							local new_pythonpath = site_packages .. ":" .. root_dir .. ":" .. current_pythonpath
							vim.env.PYTHONPATH = new_pythonpath
							--print("Set PYTHONPATH to:", new_pythonpath)
						end
					end
				end,
				flags = {
					debounce_text_changes = 150,
				},
			})

			-- TypeScript/JavaScript LSP
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			-- HTML LSP
			lspconfig.html.setup({
				capabilities = capabilities,
			})

			-- CSS LSP
			lspconfig.cssls.setup({
				capabilities = capabilities,
			})

			-- Tailwind CSS LSP
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})

			-- Emmet LSP
			lspconfig.emmet_ls.setup({
				capabilities = capabilities,
				filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
			})

			-- ESLint LSP
			lspconfig.eslint.setup({
				capabilities = capabilities,
			})

		end,
	},
}
