return {
  'navarasu/onedark.nvim',
  priority = 1000,
  event = 'UIEnter',
  config = function()
    local onedark = require 'onedark'

    onedark.setup {
      transparent = true,
    }

    onedark.load()
  end,
}
