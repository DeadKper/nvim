local icons = require('core.config.icons')

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
          'branch', 'diff',
          {
            'diagnostics',

            symbols = icons.diagnostics,
          }
        },
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
        char = icons.misc.indents.center,
        tab_char = icons.misc.indents.center,
      },
      scope = { enabled = false },
    },
  },

  {
    -- Add animation to indentation guide
    'echasnovski/mini.indentscope',
    opts = {
    },
    init = function()
      -- Disable indentscope for the following file types
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      -- Apply settings on ui attachment
      vim.api.nvim_create_autocmd('UIEnter', {
        callback = function()
          -- Set color
          vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#a0a8b7' })
          -- Config indentscope
          local indentscope = require('mini.indentscope')
          indentscope.setup({
            symbol = icons.misc.indents.center,
            options = { try_as_border = true },
            draw = {
              animation = indentscope.gen_animation.none(),
              delay = 50,
            },
          })
        end,
      })
    end,
  },

  -- Icons
  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
