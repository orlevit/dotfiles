-- Molten.nvim configuration optimized for Kitty terminal
-- This configuration enables image rendering through Kitty's graphics protocol

return {
  "benlubas/molten-nvim",
  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  build = ":UpdateRemotePlugins",
  init = function()
    -- These configuration options should be set before the plugin loads
    
    -- -- Enable image rendering through Kitty graphics protocol
    -- vim.g.molten_image_provider = "image.nvim"
    
    -- Set output window type to floating window
    vim.g.molten_output_win_style = "minimal"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_output_win_max_width = math.floor(vim.o.columns * 0.8)

    vim.g.molten_output_win_border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
    
    -- Auto-open output window on evaluation
    vim.g.molten_auto_open_output = true
    
    -- Show virtual text for output
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
    
    -- Image options for Kitty
    vim.g.molten_image_location = "float"
    vim.g.molten_wrap_output = true
    vim.g.molten_output_show_more = true
    
    -- Cover empty lines when output is shown
    vim.g.molten_cover_empty_lines = false
    
    -- Copy output to system clipboard (disable if pyperclip issues)
    vim.g.molten_copy_output = true
    
    -- Enter output behavior
    vim.g.molten_enter_output_behavior = "open_and_enter"
    
    -- Use borders
    vim.g.molten_output_win_cover_gutter = true
    
    -- Tick rate for updating
    vim.g.molten_tick_rate = 500
  end,
  config = function()
   ---- If only one kernel is available, it uses that automatically
   -- If multiple kernels exist, it tries to match your environment (conda/venv name)
   -- Falls back to the first Python kernel or python3
   -- Helper function to get available kernels
    local function get_available_kernels()
      local handle = io.popen("jupyter kernelspec list --json 2>/dev/null")
      if not handle then
        return {"python3"} -- fallback
      end
      
      local result = handle:read("*a")
      handle:close()
      
      if not result or result == "" then
        return {"python3"} -- fallback
      end
      
      -- Parse JSON to get kernel names
      local success, kernels_data = pcall(vim.json.decode, result)
      if not success or not kernels_data or not kernels_data.kernelspecs then
        return {"python3"} -- fallback
      end
      
      local kernels = {}
      for kernel_name, _ in pairs(kernels_data.kernelspecs) do
        table.insert(kernels, kernel_name)
      end
      
      return #kernels > 0 and kernels or {"python3"}
    end
    
    -- Helper function to detect best Python kernel
    local function detect_python_env()
      local available_kernels = get_available_kernels()
      
      -- If there's only one kernel, use it
      if #available_kernels == 1 then
        return available_kernels[1]
      end
      
      -- Look for Python kernels in order of preference
      local python_kernels = {}
      for _, kernel in ipairs(available_kernels) do
        if kernel:match("python") or kernel:match("py") then
          table.insert(python_kernels, kernel)
        end
      end
      
      -- If no python kernels found, use the first available
      if #python_kernels == 0 then
        return available_kernels[1]
      end
      
      -- Check environment and try to match kernel names
      local conda_env = vim.env.CONDA_DEFAULT_ENV
      local venv = vim.env.VIRTUAL_ENV
      
      -- Look for conda environment match
      if conda_env and conda_env ~= "" then
        for _, kernel in ipairs(python_kernels) do
          if kernel:lower():find(conda_env:lower()) then
            return kernel
          end
        end
      end
      
      -- Look for venv match
      if venv and venv ~= "" then
        local venv_name = vim.fn.fnamemodify(venv, ":t"):lower()
        for _, kernel in ipairs(python_kernels) do
          if kernel:lower():find(venv_name) then
            return kernel
          end
        end
      end
      
      -- Default to first Python kernel or python3
      return python_kernels[1] or "python3"
    end
    
    -- Smart initialization function
    local function smart_molten_init()
      local kernel = detect_python_env()
      local available = get_available_kernels()
      
      vim.notify("Available kernels: " .. table.concat(available, ", "), vim.log.levels.INFO)
      vim.notify("Selected kernel: " .. kernel, vim.log.levels.INFO)
      
      vim.cmd("MoltenInit " .. kernel)
    end

    -- Function to choose kernel interactively
    local function choose_molten_kernel()
      local available = get_available_kernels()
      
      if #available == 1 then
        vim.cmd("MoltenInit " .. available[1])
        vim.notify("Using kernel: " .. available[1], vim.log.levels.INFO)
        return
      end
      
      vim.ui.select(available, {
        prompt = "Select kernel:",
      }, function(choice)
        if choice then
          vim.cmd("MoltenInit " .. choice)
          vim.notify("Using kernel: " .. choice, vim.log.levels.INFO)
        end
      end)
    end

   ---- 
    
    -- Key mappings for molten
    local keymap = vim.keymap.set
    
    -- Initialize kernel
    keymap("n", "<leader>mi", smart_molten_init, { noremap = true, silent = true, desc = "Initialize molten kernel (smart)" })
    keymap("n", "<leader>mI", choose_molten_kernel, { noremap = true, silent = true, desc = "Choose molten kernel" })
    keymap("n", "<leader>mM", ":MoltenInit<CR>", { noremap = true, silent = true, desc = "Initialize molten kernel (manual)" })
    keymap("n", "<leader>mk", ":MoltenKernel<CR>", { noremap = true, silent = true, desc = "Show molten kernel info" })
    
    -- Evaluate code
    -- keymap("n", "<leader>me", ":MoltenEvaluateOperator<CR>", {noremap = true, silent = true,  desc = "Evaluate operator" })
    keymap("n", "<leader>ml", ":MoltenEvaluateLine<CR>", {noremap = true, silent = true,  desc = "Evaluate line" })
    keymap("v", "<leader>ml", ":<C-u>MoltenEvaluateVisual<CR>gv", {noremap = true, silent = true,  desc = "Evaluate visual selection" })
    keymap("n", "<leader>mc", ":MoltenReevaluateCell<CR>", {noremap = true, silent = true,  desc = "Re-evaluate current cell" })
    keymap("n", "<leader>ma", ":MoltenReevaluateAll<CR>", {noremap = true, silent = true,  desc = "Run all" })
    
    -- Output management
    keymap("n", "<leader>me", ":noautocmd MoltenEnterOutput<CR>", {noremap = true, silent = true,  desc = "Enter molten output" })
    -- keymap("n", "<leader>mh", ":MoltenHideOutput<CR>", { noremap = true, silent = true, desc = "Hide molten output" })
    keymap("n", "<leader>md", ":MoltenDelete<CR>", {noremap = true, silent = true,  desc = "Delete molten output" })
    keymap("n", "<leader>mt", function()
      local new = not vim.g.molten_auto_open_output
      vim.g.molten_auto_open_output = new
      vim.fn.MoltenUpdateOption("auto_open_output", new)
    end, { desc = "Toggle molten output" })
    
    -- Jupyter notebook functions
    keymap("n", "<leader>mp", ":MoltenOpenInBrowser<CR>", {noremap = true, silent = true,  desc = "Open output in browser" })
    keymap("n", "<leader>ms", ":MoltenSave<CR>", {noremap = true, silent = true,  desc = "Save output" })
    
    -- Clear and restart
    keymap("n", "<leader>mx", ":MoltenInterrupt<CR>", {noremap = true, silent = true,  desc = "Interrupt kernel" })
    keymap("n", "<leader>mr", ":MoltenRestart!<CR>", {noremap = true, silent = true,  desc = "Restart kernel" })
    
    -- Navigation between cells (for notebook-style files)
    keymap("n", "]c", ":MoltenNext<CR>", {noremap = true, silent = true,  desc = "Go to next molten cell" })
    keymap("n", "[c", ":MoltenPrev<CR>", {noremap = true, silent = true,  desc = "Go to previous molten cell" })
    
    -- Auto commands for better integration
    local molten_group = vim.api.nvim_create_augroup("MoltenConfig", { clear = true })
    
    -- Helper function to check if Molten is available
    local function is_molten_available()
      return vim.fn.exists(':MoltenInit') == 2
    end
    
    -- -- Auto-initialize kernel for Python files (only if Molten is loaded)
    -- vim.api.nvim_create_autocmd("FileType", {
    --   group = molten_group,
    --   pattern = "python",
    --   callback = function()
    --     -- Wait for plugin to be fully loaded, then initialize
    --     vim.defer_fn(function()
    --       if is_molten_available() then
    --         vim.cmd("MoltenInit python3")
    --       end
    --     end, 1000) -- Increased delay to ensure plugin is loaded
    --   end,
    -- })
    -- 
    -- -- Auto-initialize for Jupyter notebook files
    -- vim.api.nvim_create_autocmd("BufRead", {
    --   group = molten_group,
    --   pattern = "*.ipynb",
    --   callback = function()
    --     vim.defer_fn(function()
    --       if is_molten_available() then
    --         vim.cmd("MoltenInit python3")
    --       end
    --     end, 1000)
    --   end,
    -- })
    
    -- Set up better syntax highlighting for code cells
    vim.api.nvim_create_autocmd("FileType", {
      group = molten_group,
      pattern = { "python", "ipynb" },
      callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "n"
      end,
    })
  end,
  dependencies = {
    -- Better cell navigation for Python files
    {
      "GCBallesteros/NotebookNavigator.nvim",
      keys = {
        -- { "]h", function() require("notebook-navigator").move_cell "d" end },
        -- { "[h", function() require("notebook-navigator").move_cell "u" end },
        { "<C-CR>", function() require("notebook-navigator").run_cell() end, {noremap = true, silent = true, desc = "Run cell" }},
        { "<S-CR>", function() require("notebook-navigator").run_and_move() end, {noremap = true, silent = true, desc = "Run cell & Go next" }},
      },
      dependencies = {
        "echasnovski/mini.comment",
        "akinsho/toggleterm.nvim", -- optional for better terminal integration
      },
      event = "VeryLazy",
      config = function()
        local nn = require("notebook-navigator")
        nn.setup({ 
          activate_hydra = false,
          repl_provider = "molten"
        })
      end,
    },
    -- Optional: Better Jupyter notebook support
    {
      "GCBallesteros/jupytext.nvim",
      config = function()
        require("jupytext").setup({
          style = "markdown",
          output_extension = "md",
          force_ft = "markdown",
        })
      end,
      -- Uncomment if you want to use jupytext
      -- lazy = false,
    },
  },
}
