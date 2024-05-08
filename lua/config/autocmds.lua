-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local augroup_num_lines = vim.api.nvim_create_augroup('numbered-lines', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  group = augroup_num_lines,
  callback = function()
    vim.opt.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd({ 'InsertLeave', 'UIEnter' }, {
  group = augroup_num_lines,
  callback = function()
    vim.opt.relativenumber = true
  end,
})
