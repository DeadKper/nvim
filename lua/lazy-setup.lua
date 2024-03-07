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
local folders = { 'plugins' }

for _, folder in ipairs(folders) do
  local path = vim.loop.fs_scandir(vim.fn.stdpath 'config' .. '/lua/' .. folder)
  if path ~= nil then
    local file
    local plugin = vim.loop.fs_scandir_next(path)
    while plugin ~= nil do
      file = plugin:match '(.+)[.]lua$'
      if file ~= nil then
        table.insert(plugins, require(folder .. '.' .. file))
      end
      plugin = vim.loop.fs_scandir_next(path)
    end
  end
end

require('lazy').setup(plugins)
