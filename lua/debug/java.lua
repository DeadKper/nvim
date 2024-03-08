local dap = require 'dap'
---@diagnostic disable-next-line:param-type-mismatch
local name = require('utils').find_root 'java'
local main = vim.fn.system({ 'rg', '-l', [[^\s*public static void main\(]], '--pre-glob', '**.java'}):match '(.+[.]java)'
local package = vim.fn.system { 'rg', '^package [\\w.]+;', main }

dap.configurations.java = {
  {
    -- You need to extend the classPath to list your dependencies.
    -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
    classPaths = {},

    -- If using multi-module projects, remove otherwise.
    projectName = name,

    javaExec = vim.fn.system { 'which', 'java' },
    ---@diagnostic disable-next-line:need-check-nil
    mainClass = package:match '^package (.+);' .. '.' .. vim.fs.basename(main):match '(.+)[.]java$',

    -- If using the JDK9+ module system, this needs to be extended
    -- `nvim-jdtls` would automatically populate this property
    modulePaths = {},
    name = 'Launch ' .. name,
    request = 'launch',
    type = 'java',
  },
}
