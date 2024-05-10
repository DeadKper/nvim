require('plugins.lazy') -- Bootstrap lazy

if vim.g.vscode then
  require('lazy').setup({
    require('plugins.mini'),
  })
  return
end

require('lazy').setup({
  -- Load theme
  require('plugins.onedark'),

  -- Load utilities
  require('plugins.neovim-session-manager'),
  require('plugins.dashboard'),
  require('plugins.treesitter'),
  require('plugins.telescope'),
  require('plugins.fugitive'),
  require('plugins.gitsigns'),
  require('plugins.mini'),
  require('plugins.lualine'),
  require('plugins.comment'),
  require('plugins.suda'),
  require('plugins.ufo'),
  require('plugins.harpoon'),
  require('plugins.todo-comments'),
  require('plugins.trouble'),
  require('plugins.which-key'),
  require('plugins.neoconf'),
  require('plugins.lint'),
  require('plugins.virt-column'),
  require('plugins.indent-blankline'),

  -- Load indent helpers
  require('plugins.sleuth'),
  require('plugins.conform'),

  -- Load lsps at the end
  require('plugins.lsps'),
})
