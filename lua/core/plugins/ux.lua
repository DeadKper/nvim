return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {},
    config = function()
      -- Document existing key chains
      local mappings = {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[F]iles', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
        ['<leader>p'] = { name = '[P]royect', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>y'] = 'which_key_ignore',
      }

      mappings['<leader>h#'] = { desc = '[H]arpoon jump to file [#]' }
      for i = 1, 10, 1 do
        mappings['<leader>h' .. i % 10] = 'which_key_ignore'
      end

      require('which-key').register(mappings)
    end
  },

  -- 'gc' to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- harpoon
  {
    'ThePrimeagen/harpoon',
    --branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local map = vim.keymap.set
      local mark = require('harpoon.mark')
      local ui = require('harpoon.ui')

      map('n', '<leader>ha', mark.add_file, { desc = '[H]arpoon [A]dd file' })
      map('n', '<leader>hf', ui.toggle_quick_menu, { desc = '[H]arpoon [F]iles list' })
      map('n', '<leader>hn', ui.nav_next, { desc = '[H]arpoon [N]ext file' })
      map('n', '<leader>hp', ui.nav_prev, { desc = '[H]arpoon [P]revious file' })

      for i = 1, 10, 1 do
        map('n', '<leader>h' .. i % 10, function()
          ui.nav_file(i)
        end)
      end
    end,
  },
}
