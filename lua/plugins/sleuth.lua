return { -- Auto detection for file indentation with custom logic un lua to add default values
  'tpope/vim-sleuth',
  config = function()
    local conf = {
      ignore = { '', 'text' },
      default = {
        indent = 4,
        spaces = false,
      },
      filetype = {
        lua = {
          indent = 2,
          spaces = true,
        },
      },
    }

    local function indent()
      local data = vim.api.nvim_exec2('verbose set ts sw', { output = true }).output
      if not data:match('sleuth.vim') then
        return
      end

      local tabstop = tonumber(data:match('tabstop=([0-9]+)'))
      local shiftwidth = tonumber(data:match('shiftwidth=([0-9]+)'))

      if shiftwidth == 0 or tabstop == shiftwidth then
        if tabstop == 8 and not vim.tbl_contains(conf.ignore, vim.bo.filetype) then
          local defaults = conf.filetype[vim.bo.filetype]
          vim.bo.tabstop = defaults and defaults.indent or conf.default.indent
          vim.bo.expandtab = defaults and defaults.spaces or conf.default.spaces
          vim.bo.shiftwidth = vim.bo.tabstop
        end
      elseif tabstop < shiftwidth then
        vim.bo.shiftwidth = tabstop
      else
        vim.bo.tabstop = shiftwidth
      end
    end

    vim.api.nvim_create_user_command('DetectIndent', function()
      vim.cmd('silent Sleuth')
      indent()
    end, {})

    local augroup = vim.api.nvim_create_augroup('indent', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufFilePost', 'FileType' }, {
      group = augroup,
      callback = indent,
    })

    vim.api.nvim_create_autocmd({ 'BufNewFile' }, {
      group = augroup,
      callback = function()
        indent()
        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
          group = augroup,
          once = true,
          callback = function()
            vim.defer_fn(vim.cmd.DetectIndent, 500)
          end,
        })
      end,
    })
  end,
}
