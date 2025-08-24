
return {
  {
    "yetone/avante.nvim",
    -- build with `make` (recommended by the plugin). If you prefer prebuilt,
    -- set BUILD_FROM_SOURCE env or change config per README.
    build = vim.fn.has("win32") ~= 0 and
      "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false, -- the plugin author warns about pinning "*"
    dependencies = {
      -- required
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      -- optional but recommended for nicer UX
      "MeanderingProgrammer/render-markdown.nvim", -- render Avante outputs
      "hrsh7th/nvim-cmp",                          -- completion for mentions/commands
      "nvim-tree/nvim-web-devicons",               -- icons
      "HakonHarnes/img-clip.nvim",                 -- image paste support
      "zbirenbaum/copilot.lua",                    -- copilot provider (optional)
      "stevearc/dressing.nvim",                    -- nicer input UI
      "folke/snacks.nvim",                         -- modern input UI
    },
    opts = {
      -- Default mode & provider
      provider = "openai",      -- use OpenAI (ChatGPT / API key)
      mode = "agentic",        -- "agentic" or "legacy" ; agentic uses tools
      -- Provider-specific configuration
      providers = {
        openai = {
          -- OpenAI REST endpoint (default)
          endpoint = "https://api.openai.com/v1",
          -- The name of the environment variable holding your key:
          -- Avante will read os.getenv("OPENAI_API_KEY") internally when needed.
          -- Set that env var (example above).
          api_key = "OPENAI_API_KEY",
          -- A model that works for edits + reasoning. Change if you have access.
          model = "gpt-4o",
          timeout = 60000, -- ms
          -- extra_request_body will be merged to the API request body if used
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192,
          },
        },
        morph = {
          endpoint = "https://api.morphllm.com/v1",
          api_key = "MORPH_API_KEY",
          model = "morph-v3-fast",
        },
      },

      -- Input UI: "native" | "dressing" | "snacks"
      input = {
        provider = "snacks",
        provider_opts = {
          title = "Avante: prompt",
          placeholder = "Ask the AI about the current file / selection...",
        },
      },

      -- Behavior toggles
      behaviour = {
        enable_fastapply = true, -- set true only if you set up Morph apply service (see README)
      },

      -- RAG service off by default; enable only if you want local RAG container
      rag_service = {
        enabled = false,
        -- if enabling, set llm/embed provider/api_key fields appropriately
      },

      -- optional: file selector provider; can be "telescope" or "fzf_lua" or "mini_pick"
      selector = {
        provider = "telescope",
      },

      -- UI tweaks (feel free to change)
      ui = {
        sidebar_width = 48,
        float = {
          max_width = 160,
          max_height = 40,
        },
      },

      -- custom prompts directory (optional):
      -- override_prompt_dir = vim.fn.expand("~/.config/nvim/avante_prompts"),
    },

    config = function(_, opts)
      -- ensure auxiliary plugins are configured first (if present)
      local has = vim.fn.has
      -- If render-markdown is installed, register Avante filetype
      pcall(function()
        require("render-markdown").setup({ file_types = { "markdown", "Avante" } })
      end)

      -- call setup
      require("avante").setup(opts)

      -- Keymaps: adjust to taste
      local map = vim.keymap.set
      -- Toggle sidebar
      map("n", "<leader>a", "<cmd>AvanteToggle<CR>", { desc = "Avante: Toggle" })
      -- Open inline prompt
      map("n", "<leader>ap", "<cmd>Avante<CR>", { desc = "Avante: Open prompt" })
      -- Switch provider (useful if you added multiple providers)
      map("n", "<leader>as", "<cmd>AvanteSwitchProvider<CR>", { desc = "Avante: Switch Provider" })
      -- History
      map("n", "<leader>ah", "<cmd>AvanteHistory<CR>", { desc = "Avante: History" })
      -- Stop current request
      map("n", "<leader>aS", "<cmd>AvanteStop<CR>", { desc = "Avante: Stop request" })
    end,
  },
}
