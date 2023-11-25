-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
--vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Custom settings ]]

-- Set tab size to 4 by default
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Keep 8 lines of padding during scroll
vim.o.scrolloff = 8

-- Indent conf
vim.o.smartindent = true
vim.opt.breakindentopt = { 'shift:2', 'sbr' }

-- Remove swapfile
vim.opt.swapfile = false

-- Execute on ui attachment
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    -- Make cursor blue
    vim.api.nvim_set_hl(0, "Cursor", { bg = '#61afef' })
    -- Make cursor blink
    vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,a:blinkon100'
  end
})

-- Remove relative line numbers on insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.wo.relativenumber = false
  end
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    vim.wo.relativenumber = true
  end
})
