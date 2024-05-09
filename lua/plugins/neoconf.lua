return { -- Allow configuration via vscode json files
  'folke/neoconf.nvim',
  event = 'UIEnter',
  config = function()
    require('config.lsp').add_ensure_install('json-lsp')
    require('neoconf').setup({})
  end,
}
