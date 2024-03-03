return {
  -- Theme inspired by Atom
  'navarasu/onedark.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    local color = require 'onedark'

    -- Configure theme
    color.setup {
      transparent = true,
      lualine = {
        transparent = true,
      },
      diagnostics = {
        darker = false,
        undercurl = true,
        background = false,
      },
    }

    -- Load the colorscheme here
    vim.cmd.colorscheme 'onedark'

    -- You can configure highlights by doing something like
    vim.cmd.hi 'Comment gui=none'
  end,
}
