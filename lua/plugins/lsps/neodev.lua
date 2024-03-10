require('plugins.lsps.conf').auto_install({ 'lua_ls', 'stylua' })

return {
  { 'folke/neodev.nvim', opts = {} }, -- Setup lua_ls to have better neovim integration
}
