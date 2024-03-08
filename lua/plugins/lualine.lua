local icons = require 'icons'

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      theme = 'onedark',
      component_separators = icons.indents.center,
      section_separators = '',
    },
    sections = {
      lualine_b = {
        'branch',
        'diff',
        {
          'diagnostics',
          symbols = icons.diagnostics,
        },
      },
    },
  },
}
