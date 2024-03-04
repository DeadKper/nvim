return { -- harpoon
  'ThePrimeagen/harpoon',
  event = 'VimEnter',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local harpoon = require 'harpoon'

    ---@diagnostic disable-next-line:missing-parameter
    harpoon:setup()

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():append()
    end, { desc = '[H]arpoon [A]ppend' })
    vim.keymap.set('n', '<leader>hf', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon [F]iles' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end)

    for i = 1, 10, 1 do
      vim.keymap.set('n', '<leader>h' .. i % 10, function()
        harpoon:list():select(i)
      end)
    end
  end,
}
