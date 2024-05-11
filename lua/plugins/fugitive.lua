return { -- Git integration in neovim
  'tpope/vim-fugitive',
  dependencies = { 'seanbreckenridge/yadm-git.vim' },
  event = 'VeryLazy',
  config = function()
    vim.g.yadm_git_gitgutter_enabled = 0
  end,
}
