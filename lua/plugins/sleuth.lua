return {
  'tpope/vim-sleuth',
  event = 'VimEnter',
  config = function()
    local indent = {
      valid = { 2, 4 },
      default = 4,
    }

    local function fix_indent()
      if vim.bo.expandtab then
        if not vim.tbl_contains(indent.valid, vim.bo.tabstop) then
          vim.bo.shiftwidth = indent.default -- Set shiftwidth to an acceptable value
        end
      else
        if not vim.tbl_contains(indent.valid, vim.bo.shiftwidth) then
          vim.bo.shiftwidth = indent.default -- Set shiftwidth to an acceptable value
        end
      end
      vim.bo.tabstop = vim.bo.shiftwidth -- Set tabstop to shiftwidth
      vim.bo.softtabstop = 0 -- Disable softtabstop
    end

    -- Set autocmd on UIEnter so it loads after sleuth
    vim.api.nvim_create_autocmd({ 'UIEnter' }, {
      once = true,
      group = vim.api.nvim_create_augroup('after-sleuth', { clear = true }),
      callback = function()
        -- Set initial indentation
        fix_indent()

        vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost', 'BufFilePost', 'FileType' }, {
          group = vim.api.nvim_create_augroup('after-sleuth', { clear = true }),
          callback = fix_indent,
        })
      end,
    })
  end,
}
