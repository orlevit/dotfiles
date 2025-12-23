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
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "antosha417/nvim-lsp-file-operations", config = true },
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
            if not vim.lsp or not vim.lsp.config then
                return
            end

            local lsp = vim.lsp
            local default_config = lsp.config["*"] or {}
            local default_capabilities = default_config.capabilities
                and vim.deepcopy(default_config.capabilities)
                or lsp.protocol.make_client_capabilities()
            local capabilities = require("cmp_nvim_lsp").default_capabilities(default_capabilities)

            lsp.config["*"] = vim.tbl_deep_extend("force", {}, default_config, {
                capabilities = capabilities,
            })

            local ok_mti, mason_tool_installer = pcall(require, "mason-tool-installer")
            if ok_mti and type(mason_tool_installer.setup) == "function" then
                mason_tool_installer.setup({
                    ensure_installed = {
                        "prettier",
                        "stylua",
                        "isort",
                        "black",
                    },
                })
            end

            -- Python virtual environment detection
            local function get_python_venv()
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    return { python = venv .. "/bin/python", venv_path = venv }
                end
                local cwd = vim.fn.getcwd()
                local common_venv_names = { "venv", ".venv", "env", ".env", "bridgit_env" }
                for _, name in ipairs(common_venv_names) do
                    local venv_path = cwd .. "/" .. name
                    local python_path = venv_path .. "/bin/python"
                    if vim.fn.executable(python_path) == 1 then
                        return { python = python_path, venv_path = venv_path }
                    end
                end
                return { python = "python3", venv_path = nil }
            end

            -- Function to detect Python source directories
            local function get_python_source_paths(root_dir)
                local source_paths = {}
                local common_src_dirs = { "src", "lib", "app", "project" }
                
                -- Always include the root directory
                table.insert(source_paths, root_dir)
                
                -- Check for common source directories
                for _, src_dir in ipairs(common_src_dirs) do
                    local src_path = root_dir .. "/" .. src_dir
                    if vim.fn.isdirectory(src_path) == 1 then
                        table.insert(source_paths, src_path)
                    end
                end
                
                -- Look for directories containing __init__.py (Python packages)
                local function find_python_packages(dir, max_depth)
                    if max_depth <= 0 then return end
                    
                    local handle = vim.loop.fs_scandir(dir)
                    if not handle then return end
                    
                    while true do
                        local name, type = vim.loop.fs_scandir_next(handle)
                        if not name then break end
                        
                        if type == "directory" and not name:match("^%.") then
                            local full_path = dir .. "/" .. name
                            local init_py = full_path .. "/__init__.py"
                            
                            if vim.fn.filereadable(init_py) == 1 then
                                -- Add the parent directory of the package, not the package itself
                                if not vim.tbl_contains(source_paths, dir) then
                                    table.insert(source_paths, dir)
                                end
                            end
                            
                            -- Recurse into subdirectories
                            find_python_packages(full_path, max_depth - 1)
                        end
                    end
                end
                
                -- Search for Python packages (limit depth to avoid performance issues)
                find_python_packages(root_dir, 3)
                
                return source_paths
            end

            -- Function to setup PYTHONPATH
            local function setup_pythonpath(root_dir, venv_path)
                local source_paths = get_python_source_paths(root_dir)
                local pythonpath_parts = {}
                
                -- Add virtual environment site-packages if available
                if venv_path then
                    local python_version = vim.fn.system(venv_path .. "/bin/python --version"):match("Python (%d+%.%d+)")
                    if python_version then
                        local site_packages = venv_path .. "/lib/python" .. python_version .. "/site-packages"
                        table.insert(pythonpath_parts, site_packages)
                    end
                end
                
                -- Add detected source paths
                for _, path in ipairs(source_paths) do
                    table.insert(pythonpath_parts, path)
                end
                
                -- Add existing PYTHONPATH
                local existing_pythonpath = vim.env.PYTHONPATH or ""
                if existing_pythonpath ~= "" then
                    table.insert(pythonpath_parts, existing_pythonpath)
                end
                
                local new_pythonpath = table.concat(pythonpath_parts, ":")
                vim.env.PYTHONPATH = new_pythonpath
                
                return source_paths
            end

            local function goto_definition_in_tab()
                -- force definitions into a fresh tab to keep the current window intact
                vim.cmd("tab split")
                vim.lsp.buf.definition()
            end

            -- Shared pylsp settings so we can reapply them if a default setup sneaks in
            local pylsp_settings = {
                pylsp = {
                    configurationSources = { "pyflakes" },
                    plugins = {
                        pycodestyle = {
                            enabled = true,
                            ignore = { "W503", "W504", "E203" },  -- Ignore Black-incompatible rules
                            maxLineLength = 120  -- Generous default, project configs will override
                        },
                        pyflakes = { enabled = true },
                        mccabe = { enabled = false },
                        pylint = { enabled = false },
                        rope_autoimport = { enabled = true, completions = { enabled = false }, code_actions = { enabled = true }, definitions = { enabled = false } },
                        rope_completion = { enabled = false },
                        jedi_completion = { enabled = true, include_params = true, include_class_objects = true, fuzzy = true },
                        jedi_definition = { enabled = true, follow_imports = true, follow_builtin_imports = true },
                        jedi_hover = { enabled = true },
                        jedi_references = { enabled = true },
                        jedi_signature_help = { enabled = true },
                        jedi_symbols = { enabled = true, all_scopes = true, include_import_symbols = true },
                        yapf = { enabled = false },
                        autopep8 = { enabled = false },
                    },
                },
            }

            local function apply_pylsp_settings(client)
                if client.name ~= "pylsp" then
                    return
                end
                client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, pylsp_settings)
                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end

            -- Keymaps when LSP attaches
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function()
                    vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references in Telescope" })
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show LSP references in Quickfix" })
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
                    vim.keymap.set("n", "gt", goto_definition_in_tab, { desc = "LSP definitions in new tab" })
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Show LSP definitions" })
                    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations" })
                    -- vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Show LSP type definitions" })
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

            -- Only ensure tools are installed; configure servers manually to avoid duplicate clients.
            local ok_mlc, mason_lspconfig = pcall(require, "mason-lspconfig")
            if ok_mlc and type(mason_lspconfig.setup) == "function" then
                mason_lspconfig.setup({
                    ensure_installed = {
                        "html",
                        "lua_ls",
                        "ts_ls",
                        "cssls",
                        "tailwindcss",
                        "emmet_ls",
                        "eslint",
                        "pylsp",
                    },
                    automatic_installation = false,
                })
            end

            local servers_to_enable = {}
            local function configure_server(name, config)
                lsp.config(name, config or {})
                table.insert(servers_to_enable, name)
            end

            -- pylsp with explicit settings to kill pycodestyle diagnostics
            configure_server("pylsp", {
                init_options = { plugins = { pycodestyle = { enabled = false } } },
                settings = pylsp_settings,
                cmd_env = { PYLSP_DISABLED_PLUGINS = "pycodestyle" },
                on_attach = function(client, _)
                    apply_pylsp_settings(client)
                end,
            })

            -- custom lua_ls
            configure_server("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim", "require" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                        telemetry = { enable = false },
                    },
                },
            })

            -- Manual setup for the remaining servers
            local default_servers = { "html", "ts_ls", "cssls", "tailwindcss", "emmet_ls", "eslint" }
            for _, server in ipairs(default_servers) do
                configure_server(server)
            end

            -- Ensure only one pylsp instance stays attached (avoids stray default clients)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("PylspSingleInstance", {}),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client or client.name ~= "pylsp" then
                        return
                    end
                    apply_pylsp_settings(client)
                    local clients = vim.lsp.get_clients({ name = "pylsp" })
                    for _, c in ipairs(clients) do
                        if c.id ~= client.id then
                            vim.lsp.stop_client(c.id)
                        end
                    end
                end,
            })

            if #servers_to_enable > 0 then
                lsp.enable(servers_to_enable)
            end
        end,
    },
}
