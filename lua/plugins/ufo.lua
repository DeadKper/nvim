return { -- Better folds
  'kevinhwang91/nvim-ufo',
  event = 'UIEnter',
  dependencies = {
    'kevinhwang91/promise-async', -- Required
    'nvim-treesitter/nvim-treesitter', -- Used for fold method
    {
      'luukvbaal/statuscol.nvim', -- Configurable status column
      config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
            { text = { '%s' }, click = 'v:lua.ScSa' },
            { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          },
        })
      end,
    },
    {
      'anuvyklack/fold-preview.nvim', -- Add fold preview
      config = function()
        local fold_preview = require('fold-preview')
        fold_preview.setup({ default_keybindings = false, auto = 700 })

        vim.keymap.set('n', 'zp', fold_preview.toggle_preview, { desc = 'Toggle fold preview' })
      end,
    },
  },
  init = function()
    local folds = require('config.icons').fold
    -- Configure vim options to work with ufo
    vim.opt.fillchars = { eob = ' ', fold = ' ', foldopen = folds.open, foldsep = ' ', foldclose = folds.close }
    vim.opt.foldenable = true
    vim.opt.foldcolumn = '1'
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
  config = function()
    local ufo = require('ufo')
    vim.keymap.set('n', 'zR', ufo.openAllFolds)
    vim.keymap.set('n', 'zM', ufo.closeAllFolds)

    ---@diagnostic disable-next-line:missing-fields
    ufo.setup({
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    })
  end,
}
