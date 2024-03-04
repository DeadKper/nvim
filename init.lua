-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- [[ Set options ]]
require 'options'

-- [[ Set keymaps ]]
require 'keymaps'

-- [[ Setup autocommands ]]
require 'autocmds'

-- [[ Install and configure lazy when not in vscode ]]
if not vim.g.vscode then
  require 'lazy-setup'
end
