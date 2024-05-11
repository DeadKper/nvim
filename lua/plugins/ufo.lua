return { -- Better folds
  'kevinhwang91/nvim-ufo',
  event = 'VeryLazy',
  dependencies = {
    'kevinhwang91/promise-async', -- Required
    'nvim-treesitter/nvim-treesitter', -- Used for fold method
    {
      'anuvyklack/fold-preview.nvim', -- Add fold preview
      config = function()
        local fold_preview = require('fold-preview')
        fold_preview.setup({ default_keybindings = false, auto = nil })

        vim.keymap.set('n', 'zp', fold_preview.toggle_preview, { desc = 'Toggle fold preview' })
      end,
    },
  },
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
