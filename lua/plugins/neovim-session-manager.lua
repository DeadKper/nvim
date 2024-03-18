return {                                      -- Neovim session manager
  'Shatur/neovim-session-manager',
  dependencies = { 'nvim-lua/plenary.nvim' }, -- Required
  lazy = true,
  config = function()
    local config = require('session_manager.config')
    require('session_manager').setup({
      autoload_mode = config.AutoloadMode.Disabled,
    })
  end,
}
