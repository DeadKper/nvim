require('plugins.lazy') -- Bootstrap lazy

require('lazy').setup({
  -- Load theme
  require('plugins.onedark'),

  -- Load utilities
  require('plugins.treesitter'),
  require('plugins.telescope'),
  require('plugins.gitsigns'),
  require('plugins.mini'),

  -- Load indent helpers
  require('plugins.sleuth'),
  require('plugins.conform'),

  -- Load lsps at the end
  require('plugins.lsps'),
})
