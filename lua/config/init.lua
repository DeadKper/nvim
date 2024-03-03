require 'config.settings'
require 'config.keymaps'
require 'config.autocmds'
if not vim.g.vscode then
  require 'config.lazy'
end
