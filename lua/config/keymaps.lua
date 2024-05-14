-- Set mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.keymap.set({ 'n', 'v' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })

-- File explorer
vim.keymap.set('n', '<leader>fe', vim.cmd.Ex, { desc = '[F]ile [E]xplorer', silent = true })

-- Move selection
vim.keymap.set('v', 'J', [[:m '>+1<cr>gv=gv]], { silent = true })
vim.keymap.set('v', 'K', [[:m '<-2<cr>gv=gv]], { silent = true })
vim.keymap.set('v', 'L', '>gv')
vim.keymap.set('v', 'H', '<gv')

-- Move in insertmode
vim.keymap.set('i', '<C-j>', function()
  vim.cmd('normal j')
end, { silent = true })
vim.keymap.set('i', '<C-k>', function()
  vim.cmd('normal k')
end, { silent = true })
vim.keymap.set('i', '<C-l>', '<Right>', { silent = true })
vim.keymap.set('i', '<C-h>', '<Left>', { silent = true })

-- Move through windows quickly
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })

-- Append line below to current
vim.keymap.set('n', 'J', 'm' .. vim.g.temp_mark .. 'J`' .. vim.g.temp_mark, { silent = true })

-- Jump normally but use remaped zz
local function jump(key)
  vim.cmd('normal!' .. vim.api.nvim_replace_termcodes(key, true, true, true))
  vim.cmd('normal zz')
end

-- Jump half page with cursor in the middle
vim.keymap.set({ 'n', 'i' }, '<C-d>', function()
  jump('<C-d>')
end)
vim.keymap.set({ 'n', 'i' }, '<C-u>', function()
  jump('<C-u>')
end)

-- Jump search with cursor in the middle
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Yank to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n' }, '<leader>fy', ':%y+<cr>', { desc = '[F]ile [Y]ank' })

-- Paste over selected contents without overriding " register
vim.keymap.set('x', '<leader>p', '"_dP')
vim.keymap.set('x', '<leader>P', '"_dp')

-- Delete without saving contents to a delete register
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')

-- C-c does weird stuff sometimes
vim.keymap.set('i', '<C-c>', '<Esc>')

-- Make current file executable
vim.keymap.set('n', '<leader>fx', ':!chmod +x %', { desc = '[F]ile give E[x]ecution permission' })

-- Switch between open buffers
vim.keymap.set('n', '<C-n>', ':bnext<cr>', { silent = true })
vim.keymap.set('n', '<C-p>', ':bprev<cr>', { silent = true })

-- Make zz not center at the end of the buffer
local scroll_up = vim.api.nvim_replace_termcodes('normal! <C-y>', true, false, true)
vim.keymap.set({ 'n' }, 'zz', function()
  vim.cmd('normal! m' .. vim.g.temp_mark)
  vim.cmd('normal! zz')

  local prev
  local curr = vim.fn.winline()
  local height = vim.fn.winheight(0)
  local bufend = vim.fn.getpos('$')[2] - vim.fn.getpos('.')[2]

  while prev ~= curr and (height - curr) - bufend > 0 do
    vim.cmd(scroll_up)
    prev = curr
    curr = vim.fn.winline()
  end

  vim.cmd('normal! `' .. vim.g.temp_mark)
end, { silent = true })

-- Rename word
vim.keymap.set('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Rename word' })

-- Saner n and N behavior from https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result', silent = true })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result', silent = true })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result', silent = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result', silent = true })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result', silent = true })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result', silent = true })

-- Macro editor, don't know how to transtale this to lua
vim.cmd([[nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>]])
