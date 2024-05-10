return { -- Comment with 'gc' in visual mode or block comment with 'gb', support gc operations in normal mode
  'lukas-reineke/virt-column.nvim',
  event = 'VeryLazy',
  config = function()
    local indent = require('config.indent')
    local virt_column = require('virt-column')
    virt_column.setup({
      char = require('config.icons').lines.center,
      exclude = {
        filetypes = indent.get_exclude('colorcolumn', 'filetype'),
        buftypes = indent.get_exclude('colorcolumn', 'buftype'),
      },
    })
    indent.colorcolumn.auto_exclude = false
    indent.set_color_column()
  end,
}
