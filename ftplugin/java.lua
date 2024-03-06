local function find_root()
  ---@type table|string
  local root = vim.fs.find({
    'settings.gradle',
    'settings.gradle.kts',
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'mvnw',
    'gradlew',
    '.git',
  }, {
    upward = true,
    stop = vim.loop.os_homedir(),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })

  ---@diagnostic disable-next-line:param-type-mismatch
  if next(root) == nil then
    return vim.loop.cwd()
  else
    return vim.fs.dirname(root[1])
  end
end

local launcher = vim.fs.find(function(name) return name:match('equinox[.]launcher_') end,
  { path = vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/' })[1]
local root = find_root()

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

  root_dir = root,
}

require('jdtls').start_or_attach(config)
