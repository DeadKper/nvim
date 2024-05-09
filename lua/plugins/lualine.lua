return { -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Don't show the mode, since it's already in status line
    vim.opt.showmode = false

    local icons = require('config.icons')
    require('lualine').setup({
      options = {
        icons_enabled = true,
        component_separators = icons.lines.center,
        section_separators = '',
        ignore_focus = {
          'dapui_watches',
          'dapui_breakpoints',
          'dapui_scopes',
          'dapui_console',
          'dapui_stacks',
          'dap-repl',
        },
      },
      sections = {
        lualine_b = {
          'branch',
        },
        lualine_c = {
          'filename',
          'diff',
        },
        lualine_x = {
          { 'diagnostics', symbols = require('config.icons').diagnostics },
          'encoding',
          'fileformat',
          'filetype',
        },
      },
    })
  end,
}
