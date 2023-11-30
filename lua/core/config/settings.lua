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

-- Keep 8 lines of padding during scroll
vim.o.scrolloff = 8

-- Indent conf
vim.o.smartindent = true
vim.opt.breakindentopt = { 'shift:2', 'sbr' }

-- Remove swapfile
vim.opt.swapfile = false

-- Incremental search
vim.opt.incsearch = true

-- Undo directory
local undodir = vim.fn.stdpath('data') .. '/undo'
if not vim.loop.fs_stat(undodir) then -- Create if doesn't exist
  vim.fn.system {
    'mkdir',
    '-p',
    undodir,
  }
end
vim.o.undodir = undodir

-- Execute on ui attachment
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    -- Make cursor blue
    vim.api.nvim_set_hl(0, "Cursor", { bg = '#61afef' })
    -- Make cursor blink
    vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,a:blinkon100'
    -- Close [No Name] buffer when opening folder
    if vim.api.nvim_buf_get_name(0) .. vim.api.nvim_buf_get_number(0) == '3' then
      vim.api.nvim_buf_delete(1, {})
    end
  end
})

-- Remove relative line numbers on insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    if vim.wo.number then
      vim.opt_local.relativenumber = false
    end
  end
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    if vim.wo.number then
      vim.opt_local.relativenumber = true
    end
  end
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    -- Set tab size to 4 if greater than 4, should work with vim-sleuth if not kill me
    if (vim.o.tabstop > 4) then
      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.softtabstop = 4
    end
  end,
})
