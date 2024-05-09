return { -- Allow configuration via vscode json files
  'folke/neoconf.nvim',
  event = 'UIEnter',
  config = function()
    require('plugins.lsps.conf').auto_install('json-lsp')
    require('neoconf').setup({})
  end,
}
