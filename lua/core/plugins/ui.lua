local indent = require('core.config.icons').misc.Indent

return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    opts = {
      transparent = true,
      lualine = {
        transparent = true,
      },
      diagnostics = {
        darker = false,
        undercurl = true,
        background = false,
      },
    },
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = indent,
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = indent,
        tab_char = indent,
      },
      scope = { enabled = false },
    },
  },

  {
    -- Add animation to indentation guide
    "echasnovski/mini.indentscope",
    opts = {
      symbol = indent,
      options = { try_as_border = true },
      draw = {
        delay = 50,
      },
    },
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
