return { -- Comment with 'gc' in visual mode or block comment with 'gb', support gc operations in normal mode
  'lukas-reineke/virt-column.nvim',
  event = 'VeryLazy',
  config = function()
    local indent = require('config.indent')
    local virt_column = require('virt-column')
    virt_column.setup({
      exclude = {
        filetypes = indent.get_exclude('colorcolumn', 'filetype'),
        buftypes = indent.get_exclude('colorcolumn', 'buftype'),
      },
      highlight = 'ColorColumn',
    })
    indent.colorcolumn.auto_exclude = false
    indent.set_color_column()
    vim.cmd.hi('ColorColumn guifg=' .. indent.colorcolumn.color .. ' guibg=NONE')
  end,
}
