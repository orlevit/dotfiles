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
			--			auto_install = true,
			ensure_installed = {
				"html",
				"lua_ls",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true }, -- Import change automaticlly when file names are change
			{ "folke/neodev.nvim", opts = {} }, -- Additional Lua functionallity
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			-- For python ??
			--   local venv = os.getenv("VIRTUAL_ENV")
			--   local pylsp_cmd = venv
			--     and { venv .. "/bin/python", "-m", "pylsp" }
			--     or { "pylsp" }
			--     ??
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint", -- python linter
				},
			})
			-- Use the setup only when LSP is attach to buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function()
					-- set keybinds
					vim.keymap.set( "n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references in Telescope" })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show LSP references in Quickfix" })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Show LSP definitions" })
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations", })
          vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Show LSP type definitions", })
          vim.keymap.set({"n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions", })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename", })
          vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics", })
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics", })
          vim.keymap.set("n", "[d", function () vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Go to previous diagnostic", })
          vim.keymap.set("n", "]d", function () vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Go to next diagnostic", })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor", })
          vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP", })
				end,
			})

      vim.lsp.config("lua_ls", {
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "require" },
              },
            },
          },
        })
				--   ["pylsp"] = function()
				--   lspconfig.pylsp.setup({
				--     capabilities = capabilities,
				--     cmd = pylsp_cmd,
				--     filetypes    = { "python" },
				--     settings = {
				--       pylsp = {
				--         plugins = {
				--           pyflakes   = { enabled = true },   -- basic error checking
				--           pyls_mypy  = { enabled = false },  -- turn off mypy plugin if present
				--           pylint     = { enabled = true,
				--             -- disable the “missing module docstring” check (C0115)
				--                          args = { "--disable=C0115" },},
				--           jedi_hover = { enabled = true },   -- enable hover provider
				--         }
				--       }
				--     }
				--   })
				-- end,

			-- config = function()
			--   local capabilities = require('cmp_nvim_lsp').default_capabilities()
			--
			--   local lspconfig = require("lspconfig")
			--   local venv = os.getenv("VIRTUAL_ENV")
			--   local pylsp_cmd = venv
			--     and { venv .. "/bin/python", "-m", "pylsp" }
			--     or { "pylsp" }
			--   lspconfig.ts_ls.setup({
			--     capabilities = capabilities
			--   })
			--   lspconfig.solargraph.setup({
			--     capabilities = capabilities
			--   })
			--   lspconfig.html.setup({
			--     capabilities = capabilities
			--   })
			--   lspconfig.lua_ls.setup({
			--     capabilities = capabilities,
			--     settings = {
			--        Lua = {
			--            diagnostics = {
			--            -- Get the language server to recognize the `vim` global
			--            globals = {
			--              'vim',
			--              'require'
			--        }}}}})
			--   -- lspconfig.pyright.setup({
			--   --   capabilities = capabilities,
			--   --   filetype={"python"}
			--   -- })
			--   lspconfig.pylsp.setup({
			--     cmd = pylsp_cmd,
			--     capabilities = capabilities,
			--     filetypes    = { "python" },
			--     settings = {
			--       pylsp = {
			--         plugins = {
			--           pyflakes   = { enabled = true },   -- basic error checking
			--           pyls_mypy  = { enabled = false },  -- turn off mypy plugin if present
			--           pylint     = { enabled = true,
			--             -- disable the “missing module docstring” check (C0115)
			--                          args = { "--disable=C0115" },},
			--           jedi_hover = { enabled = true },   -- enable hover provider
			--         }
			--       }
			--     }
			--   })
			--
			--   vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			--   vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			--   vim.keymap.set("n", "gD", vim.lsp.buf.references, {})
			--   vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
