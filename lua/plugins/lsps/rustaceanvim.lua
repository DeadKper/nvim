require('plugins.lsps.conf').ignore('rust_analyzer')

return { -- Setup
  'mrcjkb/rustaceanvim',
  ft = { 'rust' },
  version = '^4', -- Recommended
}
