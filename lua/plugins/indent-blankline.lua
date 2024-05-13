return { -- Add indent guides on blank lines
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  config = function()
    local indent = require('config.indent')
    local icons = require('config.icons')
    require('ibl').setup({
      indent = {
        char = icons.lines.center,
        tab_char = icons.lines.center,
        repeat_linebreak = true,
      },
      viewport_buffer = {
        min = 100,
      },
      scope = { enabled = false },
      exclude = {
        filetypes = indent.get_exclude('blankline', 'filetype'),
        buftypes = indent.get_exclude('blankline', 'buftype'),
      },
    })
  end,
}
