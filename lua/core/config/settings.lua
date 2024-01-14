local send_keys = require('core.config.functions').send_keys
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

-- Enable wordwrap and break indent
vim.o.linebreak = true
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
local undodir = vim.fn.stdpath('state') .. '/undo'
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
    -- Add custom inlay hints colors
    vim.cmd.hi('LspInlayHint guibg=#00000000 guifg=#d8d8d8')
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

-- Set defaults for vim-sleuth
vim.go.tabstop = 4
vim.go.shiftwidth = 4
vim.go.softtabstop = -1

local indent = {
  shiftwidth = {
    valid = { 0, 2, 4 },
    default = 4,
  },

  tabstop = {
    valid = { 2, 4 },
    default = 4,
  },
}

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    -- Adjust shiftwidth to a valid config after vim-sleuth sets it
    if (not vim.tbl_contains(indent.shiftwidth.valid, vim.bo.shiftwidth)) then
      vim.bo.shiftwidth = indent.shiftwidth.default
    end
    -- Adjust tabstop to be equal to shiftwidth when possible
    if (vim.tbl_contains(indent.tabstop.valid, vim.bo.shiftwidth)) then
      vim.bo.tabstop = vim.bo.shiftwidth
    else
      vim.bo.tabstop = indent.tabstop.default
    end
  end,
})

-- Auto indent
local indent_on_save = false
vim.api.nvim_create_user_command('AutoIndentToggle', function()
  indent_on_save = not indent_on_save
  print('Setting autoindent to: ' .. tostring(indent_on_save))
end, {})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    if indent_on_save then
      send_keys([[mzgg=G`z]], 'n')
    end
  end,
})
