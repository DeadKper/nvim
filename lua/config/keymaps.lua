-- Remap for dealing with word wrap
vim.keymap.set({ 'n', 'v' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })

-- File explorer
vim.keymap.set('n', '<leader>fe', vim.cmd.Ex, { desc = '[F]ile [E]xplorer', silent = true })

-- Move selection
vim.keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]], { silent = true })
vim.keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]], { silent = true })
vim.keymap.set('v', 'L', [[>gv]])
vim.keymap.set('v', 'H', [[<gv]])

-- Move in insertmode
vim.keymap.set('i', '<C-j>', function()
  vim.cmd('normal j')
end, { silent = true })
vim.keymap.set('i', '<C-k>', function()
  vim.cmd('normal k')
end, { silent = true })
vim.keymap.set('i', '<C-l>', [[<Right>]], { silent = true })
vim.keymap.set('i', '<C-h>', [[<Left>]], { silent = true })

-- Move through windows quickly
vim.keymap.set('n', '<C-j>', [[<C-w>j]], { silent = true })
vim.keymap.set('n', '<C-k>', [[<C-w>k]], { silent = true })
vim.keymap.set('n', '<C-l>', [[<C-w>l]], { silent = true })
vim.keymap.set('n', '<C-h>', [[<C-w>h]], { silent = true })

-- Append line below to current
vim.keymap.set('n', 'J', [[mzJ`z]], { silent = true })

-- C-d/C-u does weird things with long lines so fix that here
local function scroll(key)
  local count = math.floor(vim.fn.winheight(0) / 2)
  if vim.g.vscode and count >= 50 then
    count = 16
  end

  vim.cmd([[normal ]] .. string.rep(key, count)) -- Make entire motion since mason doesn't work with 16gj/16gk
  if vim.g.vscode then
    vim.defer_fn(function()
      vim.cmd([[normal zz]])
      vim.cmd([[normal zz]]) -- Don't know why 2 times but it fixes glitchiness
    end, 15)
  else
    vim.cmd([[normal zz]])
  end
end

-- Jump half page with cursor in the middle
vim.keymap.set('n', '<C-d>', function()
  scroll('j')
end)
vim.keymap.set('n', '<C-u>', function()
  scroll('k')
end)

-- Jump search with cursor in the middle
vim.keymap.set('n', 'n', [[nzzzv]])
vim.keymap.set('n', 'N', [[Nzzzv]])

-- Yank to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set({ 'n' }, '<leader>fy', [[:%y+<cr>]], { desc = '[F]ile [Y]ank' })

-- Paste over selected contents without overriding " register
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set('x', '<leader>P', [["_dp]])

-- Delete without saving contents to a delete register
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- C-c does weird stuff sometimes on visual mode
vim.keymap.set('i', '<C-c>', [[<Esc>]])

-- Make current file executable
vim.keymap.set('n', '<leader>fx', [[<cmd>silent !chmod +x %<CR>]], { desc = '[F]ile give E[x]ecution permission' })

-- Switch between open buffers
vim.keymap.set('n', '<C-n>', [[:bnext<CR>]], { silent = true })
vim.keymap.set('n', '<C-p>', [[:bprev<CR>]], { silent = true })
