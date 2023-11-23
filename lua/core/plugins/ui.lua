return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      local theme = require('onedark')
      theme.setup({
        transparent = true,
        lualine = {
          transparent = true,
        },
      })
      theme.load()
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '▏',
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
        char = "▏",
        tab_char = "▏",
      },
      scope = { enabled = false },
    },
  },

  {
    -- Add animation to indentation guide
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "▏",
      options = { try_as_border = true },
      draw = {
        delay = 50,
      },
    },
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
