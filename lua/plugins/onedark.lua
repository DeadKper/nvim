return {
  'navarasu/onedark.nvim',
  lazy = false,
  priority = 1000, -- load this before all the other start plugins
  config = function()
    local onedark = require 'onedark'

    onedark.setup {
      transparent = true,
    }

    onedark.load()
  end,
}
