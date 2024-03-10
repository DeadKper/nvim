return { -- Allow neovim to read/write to protected files
  'lambdalisue/suda.vim',
  lazy = false,
  init = function()
    vim.g.suda_smart_edit = 1
  end,
}
