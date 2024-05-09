return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
  config = function()
    ---@diagnostic disable-next-line:missing-fields
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'vim', 'vimdoc', 'jsonc' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
