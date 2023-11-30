-- Make remaps easier
local map = vim.keymap.set

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Remap for dealing with word wrap
map('n', 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
map('n', 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Custom Keymaps ]]

-- File explorer
map('n', '<leader>fe', vim.cmd.Ex, { desc = '[F]ile [E]xplorer' })

-- Switch buffer
map('n', '<C-p>', [[:bprevious<CR>]], { desc = 'Previous buffer', silent = true })
map('n', '<C-n>', [[:bnext<CR>]], { desc = 'Next buffer', silent = true })

-- Move selection
map('v', 'J', [[:m '>+1<CR>gv=gv]])
map('v', 'K', [[:m '<-2<CR>gv=gv]])

-- Append line below to current
map('n', 'J', [[mzJ`z]])

-- Jump half page with cursor in the middle
map('n', '<C-d>', [[<C-d>zz]])
map('n', '<C-u>', [[<C-u>zz]])

-- Jump search with cursor in the middle
map('n', 'n', [[nzzzv]])
map('n', 'N', [[Nzzzv]])

-- Paste in insert mode
map('i', '<M-v>', [[<C-r>"]], { desc = 'Paste from yanked/deleted text' })
map('i', '<C-v>', [[<C-r>+]], { desc = 'Paste from clipboard' })

-- Yank + copy to clipboard
map({ 'n', 'v' }, '<leader>y', [["+y]])

-- Yank all file to clipboard
map('n', '<leader>ya', [[G$vgg^"+y<C-o><C-o>zz]], { desc = 'Yank file to clipboard' })

-- Delete/paste without yank
map({ 'n', 'v' }, '<leader>d', [["_d]])
map('x', '<leader>p', [["_dP]])

-- I trust Primeagen enough
map('i', '<C-c>', [[<Esc>]])

-- Disable 'Q'
map('n', 'Q', [[<Nop>]])

-- Replace text
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word in cursor' })

-- Open proyect in new session
map('n', '<leader>po', [[<cmd>silent !tmux-windowizer proyect-selector Enter<CR>]], { desc = '[P]royect [O]pen' })

function BdeleteAll(keep_current, force)
  local suffix = ''
  if force then
    suffix = '!'
  end
  vim.cmd([[1,$bd]] .. suffix)
  local empty = vim.api.nvim_buf_get_number(0)
  if keep_current then
    vim.cmd([[e#]])
  else
    vim.cmd.Ex()
  end
  vim.cmd([[bd ]] .. empty)
end

-- Close buffers
map('n', '<leader>fq', function() BdeleteAll(false, false) end, { desc = 'Close all buffers' })
map('n', '<leader>fQ', function() BdeleteAll(false, true) end, { desc = 'Force close all buffers' })

-- Find in file
map('n', '<leader>fs', [[/<C-r><C-w><CR>]], { desc = '[F]ile [S]earch word in cursor' })

-- Make current file executable
map('n', '<leader>fx', [[<cmd>!chmod +x %<CR>]], { desc = 'Grant current [F]ile e[X]ecution perm', silent = true })

-- Format file without lsp
map('n', '<leader>ff', [[gg=G``zz]], { desc = '[F]ormat [F]ile indent' })
