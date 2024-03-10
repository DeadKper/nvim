return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  event = 'UIEnter',
  config = function()
    local signs = {}
    for key, value in pairs(require('config.icons').git) do
      signs[key] = { text = value }
    end
    require('gitsigns').setup({
      signs = signs,
      attach_to_untracked = true,
      yadm = {
        enable = true,
      },
    })
  end,
}
