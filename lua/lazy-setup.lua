-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Scan folders and setup those plugins
local plugins = {}
local folders = { 'plugins', 'lsps' }
local utils = require 'utils'

for _, folder in ipairs(folders) do
  local found = utils.lua_files(vim.fn.stdpath 'config' .. '/lua/' .. folder)
  if found ~= nil then
    for _, file in ipairs(found) do
      table.insert(plugins, require(folder .. '.' .. file))
    end
  end
end

require('lazy').setup(plugins)
