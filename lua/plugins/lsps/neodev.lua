require('config.lsp').add_ensure_install({ 'lua-language-server', 'stylua' })

return { -- Setup lua_ls to have better neovim integration
  'folke/neodev.nvim',
  event = 'UIEnter',
  opts = {},
}
