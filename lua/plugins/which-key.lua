return { -- Useful plugin to show you pending keybinds
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local wk = require('which-key')
    wk.setup()

    -- Document existing key chains
    wk.register({
      ['<leader>f'] = { name = '[F]iles', _ = 'which_key_ignore' },
      ['<leader>d'] = 'which_key_ignore',
      ['<leader>y'] = 'which_key_ignore',
      ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    })
  end,
}
