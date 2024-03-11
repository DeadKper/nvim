require('plugins.lazy') -- Bootstrap lazy

require('lazy').setup({
  -- Load theme
  require('plugins.onedark'),
  require('plugins.auto-session'),

  -- Load utilities
  require('plugins.treesitter'),
  require('plugins.telescope'),
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

  -- Load indent helpers
  require('plugins.sleuth'),
  require('plugins.conform'),

  -- Load lsps at the end
  require('plugins.lsps'),
})
