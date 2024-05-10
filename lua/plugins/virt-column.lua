return { -- Comment with 'gc' in visual mode or block comment with 'gb', support gc operations in normal mode
  'lukas-reineke/virt-column.nvim',
  event = 'VeryLazy',
  config = function()
    local virt_column = require('virt-column')
    virt_column.setup({})
    virt_column.overwrite({
      exclude = {
        filetypes = {
          'lspinfo',
          'packer',
          'checkhealth',
          'help',
          'man',
          'TelescopePrompt',
          'TelescopeResults',
        },
      },
    })
    virt_column.update({
      exclude = {
        filetypes = {
          'dashboard',
          'fugitive',
          'Trouble',
        },
      },
      highlight = 'ColorColumn',
    })
    local column = {
      default = '80',
      filetype = {
        gitcommit = '50',
      },
      buftypes = {},
    }
    vim.cmd.hi('ColorColumn guifg=#636363 guibg=NONE')
    vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FileType' }, {
      group = vim.api.nvim_create_augroup('colorcolumn', { clear = true }),
      callback = function()
        if column.buftypes[vim.bo.buftype] then
          vim.opt.colorcolumn = column.buftypes[vim.bo.buftype]
        elseif column.filetype[vim.bo.filetype] then
          vim.opt.colorcolumn = column.filetype[vim.bo.filetype]
        else
          vim.opt.colorcolumn = column.default
        end
      end,
    })
  end,
}
