local launcher = vim.fs.find(function(name) return name:match('equinox[.]launcher_') end, { path = vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/' })[1]
local root = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1])

local config = {
  cmd = {
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. vim.fn.stdpath('data') .. '/mason/packages/jdtls/lombok.jar',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', launcher,
    '-configuration', vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux',
    '-data', '/tmp/java' .. root,
  },
}

require('jdtls').start_or_attach(config)
