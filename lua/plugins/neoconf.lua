return { -- Comment with 'gc' in visual mode or block comment with 'gb', support gc operations in normal mode
  'folke/neoconf.nvim',
  event = 'VimEnter',
  config = function()
    require('plugins.lsps.conf').auto_install('json-lsp')
    require('neoconf').setup({})
  end,
}
