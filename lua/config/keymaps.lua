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
vim.keymap.set('n', 'J', 'mzJ`z', { silent = true })

-- C-d/C-u does weird things with long lines so fix that here
local function scroll(key)
  local count = math.floor(vim.fn.winheight(0) / 2)
  if vim.g.vscode and count >= 50 then
    count = 16
  end

  local hijump = math.floor(count * 1.5)
  local bufcurr = vim.fn.getpos('.')[2]
  local bufend = vim.fn.getpos('$')[2]

  if key == 'j' and bufcurr + count <= hijump then
    count = hijump - bufcurr
  elseif key == 'k' and bufend - bufcurr + count - 1 < hijump then
    count = hijump - (bufend - bufcurr)
  end
  vim.cmd('normal! ' .. count .. 'g' .. key)

  if vim.g.vscode then
    vim.defer_fn(function()
      vim.cmd('normal zz')
      vim.cmd('normal zz') -- Don't know why 2 times but it fixes glitchiness
    end, 15)
  else
    vim.cmd('normal zz')
  end
end

-- Jump half page with cursor in the middle
vim.keymap.set({ 'n', 'i' }, '<C-d>', function()
  scroll('j')
end)
vim.keymap.set({ 'n', 'i' }, '<C-u>', function()
  scroll('k')
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
vim.keymap.set({ 'i', 'n', 'v', 'o', 'x', '!' }, '<C-c>', '<Esc>')

-- Make current file executable
vim.keymap.set('n', '<leader>fx', ':!chmod +x %', { desc = '[F]ile give E[x]ecution permission' })

-- Switch between open buffers
vim.keymap.set('n', '<C-n>', ':bnext<cr>', { silent = true })
vim.keymap.set('n', '<C-p>', ':bprev<cr>', { silent = true })

-- Make zz not center at the end of the buffer
local scroll_up = vim.api.nvim_replace_termcodes('normal! <C-y>', true, false, true)
vim.keymap.set({ 'n' }, 'zz', function()
  vim.cmd('normal! zz')

  local prev_line
  local curr_line = vim.fn.winline()
  local buffer_end = vim.fn.getpos('$')[2] - vim.fn.getpos('.')[2]
  while prev_line ~= curr_line and (vim.fn.winheight(0) - curr_line) - buffer_end > 0 do
    vim.cmd(scroll_up)
    prev_line = curr_line
    curr_line = vim.fn.winline()
  end
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
