return {
  'mfussenegger/nvim-jdtls',
  dependencies = { 'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap' },
  ft = { 'java' },
  config = function()
    local utils = require 'utils'
    local root = utils.find_root 'java'

    local config = {
      cmd = {
        'java',

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. vim.fn.stdpath 'data' .. '/mason/packages/jdtls/lombok.jar',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',

        '-jar',
        utils.find('equinox[.]launcher_', vim.fn.stdpath 'data' .. '/mason/packages/jdtls/plugins/')[1],
        '-configuration',
        vim.fn.stdpath 'data' .. '/mason/packages/jdtls/config_linux',
        '-data',
        '/tmp/java' .. root,
      },

      root_dir = root,
    }

    local jdtls = require 'jdtls'

    jdtls.start_or_attach(config)
    jdtls.setup_dap()
  end,
}
