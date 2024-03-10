return {
  -- Do completion config
  require('plugins.lsps.cmp'),

  -- Config pre lsps plugins
  require('plugins.lsps.neodev'),

  -- Do lsp config
  require('plugins.lsps.lspconfig'),
  require('plugins.lsps.mason'),
}
