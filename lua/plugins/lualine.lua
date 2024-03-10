return { -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  event = 'UIEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Don't show the mode, since it's already in status line
    vim.opt.showmode = false

    local diagnostics = {}

    for key, value in pairs(require('config.icons').diagnostics) do
      diagnostics[key] = value .. ' '
    end

    local icons = require('config.icons')
    require('lualine').setup({
      options = {
        icons_enabled = true,
        component_separators = icons.lines.center,
        section_separators = '',
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
          { 'diagnostics', symbols = diagnostics },
          'encoding',
          'fileformat',
          'filetype',
        },
      },
    })
  end,
}
