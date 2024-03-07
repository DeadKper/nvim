-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Execute on ui attachment
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    -- Add custom inlay hints colors
    vim.cmd.hi 'LspInlayHint guibg=#00000000 guifg=#d8d8d8 gui=italic'
  end,
})
