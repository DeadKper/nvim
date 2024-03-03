local icons = require 'share.icons'

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      theme = 'onedark',
      component_separators = icons.misc.indents.center,
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
