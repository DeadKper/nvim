return { -- Better folds
  'kevinhwang91/nvim-ufo',
  event = 'VeryLazy',
  dependencies = {
    'kevinhwang91/promise-async', -- Required
    'williamboman/mason.nvim', -- Setup mason before so it can extend lsp fold capabilities
  },
  config = function()
    local ufo = require('ufo')
    vim.keymap.set('n', 'zR', ufo.openAllFolds)
    vim.keymap.set('n', 'zM', ufo.closeAllFolds)
    vim.keymap.set('n', 'K', ufo.peekFoldedLinesUnderCursor, { desc = 'Fold preview' })

    ---@diagnostic disable-next-line:missing-fields
    ufo.setup()
  end,
}
