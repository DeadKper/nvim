local dap = require 'dap'
local root = require('utils').find_root 'rust'
---@diagnostic disable-next-line:param-type-mismatch
local name = vim.fs.basename(root)

dap.configurations.rust = {
  {
    name = name,
    type = 'codelldb',
    request = 'launch',
    program = function()
      vim.cmd [[silent !cargo build]]
      return root .. '/target/debug/' .. name
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    showDisassembly = 'never',
  },
}

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'codelldb',
    args = { '--port', '${port}' },
  },
}
