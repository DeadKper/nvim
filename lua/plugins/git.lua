return {
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = require('icons').git,
    },
  },

  { -- Allows usage of git inside vim
    'tpope/vim-fugitive',
    event = 'VimEnter',
    config = function()
      vim.keymap.set('n', '<leader>gd', [[:Gvdiff<CR>]], { desc = '[G]it [D]iff', silent = true })
    end,
  },
}
