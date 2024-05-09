require('config.lsp').add_ignore('rust_analyzer')

return { -- Setup
  'mrcjkb/rustaceanvim',
  ft = { 'rust' },
  version = '^4', -- Recommended
}
