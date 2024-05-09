-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local augroup_num_lines = vim.api.nvim_create_augroup('numbered-lines', { clear = true })
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group = augroup_num_lines,
  callback = function()
    if vim.opt.number then
      vim.opt.relativenumber = false
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  group = augroup_num_lines,
  callback = function()
    if vim.bo.filetype ~= 'dashboard' and vim.opt.number and vim.fn.mode() ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})
