return {
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      local signs = {}
      for key, value in pairs(require('icons').git) do
        signs[key] = { text = value }
      end
      require('gitsigns').setup({ signs = signs })
    end,
  },

  { -- Allows usage of git inside vim
    'tpope/vim-fugitive',
    event = 'VimEnter',
    config = function()
      vim.keymap.set('n', '<leader>gd', [[:Gvdiff<CR>]], { desc = '[G]it [D]iff', silent = true })
    end,
  },
}
