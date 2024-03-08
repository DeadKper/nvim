return {
  'tpope/vim-sleuth',
  config = function()
    local indent = {
      valid = { 2, 4 },
      default = 4,
    }

    local function detect_indent()
      vim.cmd [[silent Sleuth]]

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
    end

    -- Set autocmd on VimEnter so it loads after sleuth
    vim.api.nvim_create_autocmd({ 'VimEnter' }, {
      once = true,
      group = vim.api.nvim_create_augroup('sleuth-custom', { clear = true }),
      callback = function()
        -- Set initial indentation
        detect_indent()

        -- Don't let sleuth set a tabstop of 8
        vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost', 'BufFilePost', 'FileType' }, {
          group = vim.api.nvim_create_augroup('sleuth-custom', { clear = true }),
          callback = detect_indent,
        })
      end,
    })
  end
}
