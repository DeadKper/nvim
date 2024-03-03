local function send_keys(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, true)
end

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
    if not vim.tbl_contains(indent.shiftwidth.valid, vim.bo.shiftwidth) then
      vim.bo.shiftwidth = indent.shiftwidth.default
    end
    -- Adjust tabstop to be equal to shiftwidth when possible
    if vim.tbl_contains(indent.tabstop.valid, vim.bo.shiftwidth) then
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

-- -- Execute on ui attachment
-- vim.api.nvim_create_autocmd('UIEnter', {
--   callback = function()
--     -- Make cursor blue
--     vim.api.nvim_set_hl(0, 'Cursor', { bg = '#61afef' })
--     -- Make cursor blink
--     vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,a:blinkon100'
--     -- Close [No Name] buffer when opening folder
--     if vim.api.nvim_buf_get_name(0) .. vim.api.nvim_buf_get_number(0) == '3' then
--       vim.api.nvim_buf_delete(1, {})
--     end
--     -- Add custom inlay hints colors
--     vim.cmd.hi 'LspInlayHint guibg=#00000000 guifg=#d8d8d8 gui=italic'
--   end,
-- })
--
-- -- Remove relative line numbers on insert mode
-- vim.api.nvim_create_autocmd('InsertEnter', {
--   callback = function()
--     if vim.wo.number then
--       vim.opt_local.relativenumber = false
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd('InsertLeave', {
--   callback = function()
--     if vim.wo.number then
--       vim.opt_local.relativenumber = true
--     end
--   end,
-- })
