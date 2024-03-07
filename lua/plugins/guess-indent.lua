return { -- Detect tabstop and shiftwidth automatically
  'NMAC427/guess-indent.nvim',
  event = 'VimEnter',
  lazy = true,
  config = function()
    require('guess-indent').setup { auto_cmd = false }

    local indent = {
      valid = { 2, 4 },
      default = 4,
      expandtab = false,
    }

    local function set_indent()
      vim.cmd [[silent lua require('guess-indent').set_from_buffer 'auto_cmd']]
      -- Adjust just in case it resolves to 8 or something since it happened with vim-sleuth
      if not vim.tbl_contains(indent.valid, vim.bo.shiftwidth) then
        vim.bo.tabstop = indent.default
        vim.bo.shiftwidth = indent.default
        vim.bo.softtabstop = indent.default
        vim.bo.expandtab = indent.expandtab
      end
    end

    local autocmd_group = vim.api.nvim_create_augroup('GuessIndent', { clear = true })

    vim.api.nvim_create_autocmd('BufReadPost', { group = autocmd_group, callback = set_indent })
    vim.api.nvim_create_autocmd('BufNewFile', {
      group = autocmd_group,
      callback = function()
        vim.api.nvim_create_autocmd('BufWritePost', { once = true, group = autocmd_group, callback = set_indent })
      end,
    })
  end,
}
