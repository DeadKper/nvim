return {
  'tpope/vim-sleuth',
  event = 'BufWinEnter',
  config = function()
    local indent = {
      valid = { 2, 4 },
      default = 4,
    }

    -- Don't let sleuth set a tabstop of 8
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost', 'BufFilePost', 'FileType' }, {
      group = vim.api.nvim_create_augroup('sleuth-fix-indent', { clear = true }),
      callback = function()
        if vim.bo.expandtab then
          if vim.tbl_contains(indent.valid, vim.bo.tabstop) then
            vim.bo.tabstop = indent.default
            vim.bo.shiftwidth = indent.default
          end
        else
          if not vim.tbl_contains(indent.valid, vim.bo.shiftwidth) then
            vim.bo.shiftwidth = indent.default
          end
          vim.bo.tabstop = vim.bo.shiftwidth
        end
      end,
    })
  end
}
