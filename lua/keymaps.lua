-- Make remaps easier
local map = vim.keymap.set

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
-- vim.opt.hlsearch = true
-- vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Custom Keymaps ]]

-- Remap for dealing with word wrap
map({ 'n', 'v' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
map({ 'n', 'v' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })

-- Remap to move in insert mode
map('i', '<C-k>', [[<C-o>gk]], { silent = true })
map('i', '<C-j>', [[<C-o>gj]], { silent = true })
map('i', '<C-h>', [[<Left>]], { silent = true })
map('i', '<C-l>', [[<Right>]], { silent = true })

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
-- map('i', '<M-v>', [[<C-r>"]], { desc = 'Paste from yanked/deleted text' })
-- map('i', '<C-v>', [[<C-r>+]], { desc = 'Paste from clipboard' })

-- Yank + copy to clipboard
-- map({ 'n', 'v' }, '<leader>y', [["+y]])

-- Yank all file to clipboard
map('n', '<leader>fy', [[mzG$vgg^"+y`z]], { desc = '[F]ile [Y]ank' })

-- Delete/paste without yank
-- map({ 'n', 'v' }, '<leader>d', [["_d]])
-- map('x', '<leader>p', [["_dP]])

-- Delete only deletes, don't yank
map('x', 'd', [["_d]])

-- Paste without yanking to clipboard, don't know why this works but it does
map('x', 'p', [["+P]])

-- I trust Primeagen enough
map('i', '<C-c>', [[<Esc>]])

-- Disable 'Q'
map('n', 'Q', [[<Nop>]])

-- Replace text
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word in cursor' })

-- Open proyect in new session
map('n', '<leader>pw', [[<cmd>silent !ps -t w<CR>]], { desc = 'Open [P]royect in tmux [W]indow' })
map('n', '<leader>ps', [[<cmd>silent !ps -t s<CR>]], { desc = 'Open [P]royect in tmux [S]ession' })

local function BdeleteAll(keep_current, force)
  local suffix = ''
  if force then
    suffix = '!'
  end
  vim.cmd([[1,$bd]] .. suffix)
  ---@diagnostic disable-next-line:undefined-field
  local empty = vim.api.nvim_buf_get_number(0)
  if keep_current then
    vim.cmd [[e#]]
  else
    vim.cmd.Ex()
  end
  vim.cmd([[bd ]] .. empty)
end

-- Close buffers
map('n', '<leader>fq', function()
  BdeleteAll(false, false)
end, { desc = 'Close all buffers' })
map('n', '<leader>fQ', function()
  BdeleteAll(false, true)
end, { desc = 'Force close all buffers' })

-- Find in file
map('n', '<leader>fs', [[/<C-r><C-w><CR>]], { desc = '[F]ile [S]earch word in cursor' })

-- Make current file executable
map('n', '<leader>fx', [[<cmd>!chmod +x %<CR>]], { desc = 'Grant current [F]ile e[X]ecution perm', silent = true })

-- Format file without lsp
-- map('n', '<leader>ff', [[mzgg=G`z]], { desc = '[F]ormat [F]ile indent' })

-- Indent with tab
map('v', '<tab>', [[>gv]])
map('v', '<S-tab>', [[<gv]])

-- Delete everything in the file
map('n', '<leader>fd', [[ggdG]], { desc = '[F]ile [D]elete' })

-- Diff open files
map('n', '<leader>dd', function()
  vim.cmd 'windo diffthis'
end, { desc = '[D]ocument [D]iff' })

map('n', '<leader>do', function()
  vim.cmd 'windo diffoff'
end, { desc = '[D]ocument diff [O]ff' })
