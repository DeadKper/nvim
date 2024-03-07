return {
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, event = 'VimEnter' },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- Add more icons
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { -- Allow neovim to write to protected files
    'lambdalisue/suda.vim',
    event = 'VimEnter',
    init = function()
      vim.g.suda_smart_edit = 1
    end,
  },
}
