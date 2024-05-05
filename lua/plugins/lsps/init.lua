return {
  -- Do completion config
  require('plugins.lsps.cmp'),

  -- Config pre lsps plugins
  require('plugins.lsps.neodev'),
  require('plugins.lsps.rustaceanvim'),

  -- Do lsp config
  require('plugins.lsps.lspconfig'),
  require('plugins.lsps.mason'),

  -- Setup dap
  require('plugins.lsps.dap'),
}
