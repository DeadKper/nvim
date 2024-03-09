return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = 'UIEnter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
