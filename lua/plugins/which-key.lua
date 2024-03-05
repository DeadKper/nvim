return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    local wk = require 'which-key'
    wk.setup()

    -- Document existing key chains
    local mappings = {
      ['<leader>f'] = { name = '[F]iles', _ = 'which_key_ignore' },
      ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      ['<leader>p'] = 'which_key_ignore',
      ['<leader>y'] = 'which_key_ignore',
    }

    mappings['<leader>h#'] = { desc = '[H]arpoon jump to file [#]' }
    for i = 1, 10, 1 do
      mappings['<leader>h' .. i % 10] = 'which_key_ignore'
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('which-key-lsp-attach', { clear = true }),
      callback = function()
        wk.register {
          ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
          ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
          ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
          ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        }
      end,
    })

    wk.register(mappings)
  end,
}
