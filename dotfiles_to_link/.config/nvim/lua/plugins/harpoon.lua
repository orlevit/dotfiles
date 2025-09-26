return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set("n", "<A-h>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon: add file" })

    vim.keymap.set("n", "<A-h>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: toggle quick menu" })

    vim.keymap.set("n", "<A-1>", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: select 1" })

    vim.keymap.set("n", "<A-2>", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: select 2" })

    vim.keymap.set("n", "<A-3>", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: select 3" })

    vim.keymap.set("n", "<A-4>", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: select 4" })

    vim.keymap.set("n", "<A-5>", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon: select 5" })

    -- -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set("n", "<C-S-P>", function()
    --   harpoon:list():prev()
    -- end, { desc = "Harpoon: prev file" })
    --
    -- vim.keymap.set("n", "<C-S-N>", function()
    --   harpoon:list():next()
    -- end, { desc = "Harpoon: next file" })

    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-h>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr, desc = "Harpoon: open in vsplit" })

        vim.keymap.set("n", "<C-x>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr, desc = "Harpoon: open in split" })

        vim.keymap.set("n", "<C-t>", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr, desc = "Harpoon: open in tab" })
      end,
    })
  end,
}
