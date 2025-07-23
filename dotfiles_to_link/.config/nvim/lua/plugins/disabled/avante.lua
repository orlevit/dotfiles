
return {
  "yetone/avante.nvim",
  build = "make",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- any UI deps you like...
  },
  opts = {
    provider = "ollama",
    providers = {
      ollama = {
        endpoint = "http://localhost:11434",
        model    = "codegemma:2b",                -- or "qwen2.5-coder", "deepseek-v2", etc.
        extra_request_body = {
          temperature = 0,
          max_tokens  = 5000, -- max tokens for the response(input+output) for llama2 is 8192
        }
      },
    },
  },
}
