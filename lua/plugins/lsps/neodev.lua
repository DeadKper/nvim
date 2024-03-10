require('plugins.lsps.conf').auto_install({ 'lua_ls', 'stylua' })

return { -- Setup lua_ls to have better neovim integration
  'folke/neodev.nvim',
  event = 'VimEnter',
  config = function()
    local function should_load()
      ---@diagnostic disable:cast-local-type
      local path = vim.api.nvim_buf_get_name(0)

      if path == '' then
        path = vim.loop.cwd()
      end

      if not path then
        return false
      end
      path = vim.loop.fs_realpath(path)

      if not path then
        return false
      end
      path = vim.fs.normalize(path)

      local config_root = vim.loop.fs_realpath(vim.fn.stdpath('config')) or vim.fn.stdpath('config')
      config_root = vim.fs.normalize(config_root)
      if path:find(config_root, 1, true) == 1 then
        return true
      end

      return next(vim.fs.find('lua', {
        upward = true,
        type = 'directory',
        stop = vim.loop.cwd() or path,
        path = path,
      }))
    end

    if should_load() then
      require('neodev').setup({})
    end
  end,
}
