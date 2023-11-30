local icons = require('core.config.icons')
local disabled = {
  '',
  'text',
  'markdown',
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
}

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
    config = function()
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
    init = function()
      -- Disable indentscope for the following file types
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*',
        callback = function()
          if (vim.tbl_contains(disabled, vim.o.filetype)) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })

      -- Apply settings on ui attachment
      vim.api.nvim_create_autocmd('UIEnter', {
        callback = function()
          -- Set color
          vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#a0a8b7' })
        end,
      })
    end,
  },

  -- Virtual color column
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      exclude = {
        filetypes = disabled,
      },
      char = icons.misc.indents.center,
      virtcolumn = '80',
    },
  },

  -- Icons
  { 'nvim-tree/nvim-web-devicons', lazy = true },
}
