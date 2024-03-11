require('plugins.lsps.conf').auto_install({ 'lua_ls', 'stylua' })

return { -- Setup lua_ls to have better neovim integration
  'folke/neodev.nvim',
  event = 'VimEnter',
  opts = {},
}
