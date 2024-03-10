return { -- Theme inspired by Atom
  'navarasu/onedark.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local onedark = require('onedark')

    onedark.setup({
      transparent = true,
      lualine = {
        transparent = true,
      },
      diagnostics = {
        darker = false,
        background = false,
      },
    })

    onedark.load()
  end,
}
