local conf = require('plugins.lsps.conf')
conf.auto_install({ 'rust-analyzer' })
conf.ignore('rust_analyzer')

return { -- Setup
  'mrcjkb/rustaceanvim',
  ft = { 'rust' },
  version = '^4', -- Recommended
}
