-- Make remaps easier
local map = vim.keymap.set

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Custom Keymaps ]]

-- File explorer
map('n', '<leader>fe', vim.cmd.Ex, { desc = '[F]ile [E]xplorer' })

-- Switch buffer
map('n', '<leader>fp', ':bprevious<CR>', { desc = '[F]ile [P]revious', silent = true })
map('n', '<leader>fn', ':bnext<CR>', { desc = '[F]ile [N]ext', silent = true })

-- Close current buffer
map('n', '<leader>fq', ':bdelete<CR>', { desc = '[F]ile [Q]uit', silent = true })
map('n', '<leader>fQ', ':bdelete!<CR>', { desc = '[F]ile force [Q]uit', silent = true })

-- Move selection
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Append line below to current
map('n', 'J', 'mzJ`z')

-- Jump half page with cursor in the middle
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Jump search with cursor in the middle
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Paste in insert mode
map('i', '<M-v>', '<C-r>"', { desc = 'Paste from yanked/deleted text' })
map('i', '<C-v>', '<C-r>+', { desc = 'Paste from clipboard' })

-- Yank + copy to clipboard
map({'n', 'v'}, '<leader>y', [["+y]])

-- Delete/paste without yank
map({'n', 'v'}, '<leader>d', [["_d]])
map('x', '<leader>p', [["_dP]])

-- I trust Primeagen enough
map('i', '<C-c>', '<Esc>')

-- Disable 'Q'
map('n', 'Q', '<Nop>')

-- Replace text
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word in cursor' })

-- Open proyect in new session
map('n', '<leader>po', '<cmd>silent !tmux neww proyect-selector<CR>', { desc = '[P]royect [O]pen' })

function BdeleteAll(keep_current, force)
  local suffix = ''
  if force then
    suffix = '!'
  end
  vim.api.nvim_command(':1,$bd' .. suffix)
  local empty = vim.api.nvim_buf_get_number(0)
  if keep_current then
    vim.api.nvim_command(':e#')
  else
    vim.api.nvim_command(':Ex')
  end
  vim.api.nvim_command(':bd ' .. empty)
end

-- Close buffers
map('n', '<leader>fc', function () BdeleteAll(false, false) end, { desc = '[F]iles [C]lose' })
map('n', '<leader>fC', function () BdeleteAll(false, true) end, { desc = '[F]iles force [C]lose' })

-- Find in file
map('n', '<leader>fs', [[/<C-r><C-w><CR>]], { desc = '[F]ile [S]earch word' })
