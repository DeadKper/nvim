return { -- Add indent guides on blank lines
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  config = function()
    local indent = require('config.indent')
    local icons = require('config.icons')
    require('ibl').setup({
      indent = { char = icons.lines.center },
      scope = { enabled = false },
      exclude = {
        filetypes = indent.exclude.filetype,
        buftypes = indent.exclude.buftype,
      },
    })
  end,
}
