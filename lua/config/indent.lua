local M = {
  exclude = {
    filetype = {
      'lspinfo',
      'packer',
      'checkhealth',
      'help',
      'man',
      'TelescopePrompt',
      'TelescopeResults',
      'dashboard',
      'fugitive',
      'Trouble',
      '',
    },
    buftype = {
      'terminal',
      'nofile',
      'quickfix',
      'prompt',
    },
  },
  colorcolumn = {
    default = '80',
    auto_exclude = true,
    filetype = {
      gitcommit = '50',
    },
  },
  blankline = {
    exclude = {
      filetype = {
        'gitcommit',
      },
    },
  },
}

-- Sets color column and autogroup to change column on certain filetypes
function M.set_color_column()
  local excludes = {
    filetype = M.get_exclude('colorcolumn', 'filetype'),
    buftype = M.get_exclude('colorcolumn', 'buftype'),
  }
  local function set_column()
    if
      M.colorcolumn.auto_exclude
      or vim.tbl_contains(excludes.filetype, vim.bo.filetype)
      or vim.tbl_contains(excludes.buftype, vim.bo.buftype)
    then
      return
    end

    vim.opt.colorcolumn = M.colorcolumn.buftype and M.colorcolumn.buftype[vim.bo.buftype]
      or M.colorcolumn.filetype and M.colorcolumn.filetype[vim.bo.filetype]
      or M.colorcolumn.default
  end
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FileType' }, {
    group = vim.api.nvim_create_augroup('colorcolumn', { clear = true }),
    callback = set_column,
  })
  set_column()
end

---@param plugin string plugin to get excludes for
---@param type string either 'filetype' or 'buftype'
---@return table<string> excludes list of buffers or file types to exclude
function M.get_exclude(plugin, type)
  return vim.tbl_extend('force', {}, M.exclude[type], M[plugin] and M[plugin].exclude and M[plugin].exclude[type] or {})
end

return M
