-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Show relative number lines when in insert mode
local augroup_num_lines = vim.api.nvim_create_augroup('numbered-lines', { clear = true })
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group = augroup_num_lines,
  callback = function()
    vim.opt_local.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd({ 'UIEnter' }, {
  group = augroup_num_lines,
  once = true,
  callback = function()
    local function enable_rnu()
      if vim.fn.eval('&nu') == 1 and vim.fn.mode() ~= 'i' then
        vim.opt_local.relativenumber = true
      end
    end
    vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
      group = augroup_num_lines,
      callback = enable_rnu,
    })
    enable_rnu()
  end,
})

-- Set fold leven in autocmd since diffing files seems to set fold level low
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('foldlevel', { clear = true }),
  callback = function()
    vim.opt_local.foldlevel = 99
  end,
})
