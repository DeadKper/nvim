-- Remap for dealing with word wrap
vim.keymap.set({ 'n', 'v' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })

-- File explorer
vim.keymap.set('n', '<leader>fe', vim.cmd.Ex, { desc = '[F]ile [E]xplorer', silent = true })

-- Move selection
vim.keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]], { silent = true })
vim.keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]], { silent = true })

-- Append line below to current
vim.keymap.set('n', 'J', [[mzJ`z]], { silent = true })

-- Jump half page with cursor in the middle
vim.keymap.set('n', '<C-d>', [[<C-d>zz]])
vim.keymap.set('n', '<C-u>', [[<C-u>zz]])

-- Jump search with cursor in the middle
vim.keymap.set('n', 'n', [[nzzzv]])
vim.keymap.set('n', 'N', [[Nzzzv]])

-- Yank to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set({ 'n', 'v' }, '<leader>Y', [["+Y]])

-- Paste over selected contents without overriding " register
vim.keymap.set('x', '<leader>p', [["_dp]])
vim.keymap.set('x', '<leader>P', [["_dP]])

-- Delete without saving contents to a delete register
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- C-c does weird stuff sometimes on visual mode
vim.keymap.set('i', '<C-c>', [[<Esc>]])

-- Make current file executable
vim.keymap.set('n', '<leader>fx', [[<cmd>silent !chmod +x %<CR>]], { desc = 'Grant current [F]ile e[X]ecution perm' })

-- Indent with tab
vim.keymap.set('v', '<tab>', [[>gv]])
vim.keymap.set('v', '<S-tab>', [[<gv]])