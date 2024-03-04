return {
  'kevinhwang91/nvim-ufo',
  event = 'VimEnter',
  dependencies = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
    {
      'luukvbaal/statuscol.nvim',
      config = function()
        local builtin = require 'statuscol.builtin'
        require('statuscol').setup {
          relculright = true,
          segments = {
            { text = { builtin.foldfunc },      click = 'v:lua.ScFa' },
            { text = { '%s' },                  click = 'v:lua.ScSa' },
            { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          },
        }
      end,
    },
  },
  init = function()
    vim.opt.fillchars = { eob = ' ', fold = ' ', foldopen = '', foldsep = ' ', foldclose = '' }
    vim.opt.foldenable = true
    vim.opt.foldcolumn = '1'
    vim.opt.foldlevel = 9999
    vim.opt.foldlevelstart = 9999
  end,
  config = function()
    local ufo = require 'ufo'
    vim.keymap.set('n', 'zR', ufo.openAllFolds)
    vim.keymap.set('n', 'zM', ufo.closeAllFolds)

    -- Option 3: treesitter as a main provider instead
    -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
    ---@diagnostic disable-next-line:missing-fields
    ufo.setup {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    }
  end,
}
