return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		modes = {
			search = { enable = true },
			char = { jump_labels = true },
    treesitter = {
      char_actions = function(motion)
        return {
          [","] = function(match)
            -- descend into first child node if exists
            local tsnode = match.tree
            if tsnode:child_count() > 0 then
              return tsnode:child(0)  -- select first child
            end
            return match -- fallback to current node
          end,
          [";"] = "next", -- keep next normal
        }
      end
      },
		},
	},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
