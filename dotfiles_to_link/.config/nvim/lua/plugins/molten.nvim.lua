-- Molten.nvim configuration optimized for Kitty terminal
-- This configuration enables image rendering through Kitty's graphics protocol

return {
  "benlubas/molten-nvim",
  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  build = ":UpdateRemotePlugins",
  init = function()
    -- These configuration options should be set before the plugin loads
    
    -- Enable image rendering through Kitty graphics protocol
    vim.g.molten_image_provider = "image.nvim"
    
    -- Set output window type to floating window
    vim.g.molten_output_win_style = "minimal"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_output_win_max_width = math.floor(vim.o.columns * 0.8)

    vim.g.molten_output_win_border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
    
    -- Auto-open output window on evaluation
    vim.g.molten_auto_open_output = false
    
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
    -- Key mappings for molten
    local keymap = vim.keymap.set
    
    -- Initialize kernel
    keymap("n", "<leader>mi", ":MoltenInit<CR>", { noremap = true, silent = true, desc = "Initialize molten kernel" })
    keymap("n", "<leader>mk", ":MoltenKernel<CR>", { noremap = true, silent = true, desc = "Show molten kernel info" })
    
    -- Evaluate code
    keymap("n", "<leader>me", ":MoltenEvaluateOperator<CR>", {noremap = true, silent = true,  desc = "Evaluate operator" })
    keymap("n", "<leader>ml", ":MoltenEvaluateLine<CR>", {noremap = true, silent = true,  desc = "Evaluate line" })
    keymap("v", "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", {noremap = true, silent = true,  desc = "Evaluate visual selection" })
    keymap("n", "<leader>mc", ":MoltenReevaluateCell<CR>", {noremap = true, silent = true,  desc = "Re-evaluate current cell" })
    
    -- Output management
    keymap("n", "<leader>mo", ":MoltenShowOutput<CR>", {noremap = true, silent = true,  desc = "Show molten output" })
    keymap("n", "<leader>mh", ":MoltenHideOutput<CR>", { noremap = true, silent = true, desc = "Hide molten output" })
    keymap("n", "<leader>md", ":MoltenDelete<CR>", {noremap = true, silent = true,  desc = "Delete molten output" })
    
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
    
    -- Auto-initialize kernel for Python files (only if Molten is loaded)
    vim.api.nvim_create_autocmd("FileType", {
      group = molten_group,
      pattern = "python",
      callback = function()
        -- Wait for plugin to be fully loaded, then initialize
        vim.defer_fn(function()
          if is_molten_available() then
            vim.cmd("MoltenInit python3")
          end
        end, 1000) -- Increased delay to ensure plugin is loaded
      end,
    })
    
    -- Auto-initialize for Jupyter notebook files
    vim.api.nvim_create_autocmd("BufRead", {
      group = molten_group,
      pattern = "*.ipynb",
      callback = function()
        vim.defer_fn(function()
          if is_molten_available() then
            vim.cmd("MoltenInit python3")
          end
        end, 1000)
      end,
    })
    
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
    -- Required dependency for image rendering in Kitty
    {
      "3rd/image.nvim",
      opts = {
        backend = "kitty", -- Use Kitty graphics protocol
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = 50,
        max_height_window_percentage = 50,
        kitty_method = "normal",
      },
    },
    -- Better cell navigation for Python files
    {
      "GCBallesteros/NotebookNavigator.nvim",
      keys = {
        -- { "]h", function() require("notebook-navigator").move_cell "d" end },
        -- { "[h", function() require("notebook-navigator").move_cell "u" end },
        { "<C-CR>", function() require("notebook-navigator").run_cell() end,  { noremap = true, silent = true, desc = "Run cell" } },
        { "<S-CR>", function() require("notebook-navigator").run_and_move() end, { noremap = true, silent = true, desc = "Run cell & Go next" }},
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
