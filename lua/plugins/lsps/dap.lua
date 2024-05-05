return { -- Debug adapter for neovim
  'mfussenegger/nvim-dap',
  event = 'LspAttach',
  dependencies = {
    { -- Creates debuger ui
      'rcarriga/nvim-dap-ui',
      dependencies = {
        'nvim-neotest/nvim-nio', -- Dependency
        { 'theHamsta/nvim-dap-virtual-text', opts = {} }, -- Virtual text for the debugger
      },
    },
    { -- Sets up debuggers
      'jay-babu/mason-nvim-dap.nvim',
      dependencies = 'williamboman/mason.nvim',
    },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    ---@diagnostic disable-next-line:missing-fields
    require('mason-nvim-dap').setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F4>', dap.close, { desc = 'Debug: Stop' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line:missing-fields
    dapui.setup({})

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: Toggle Debug Interface' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    for name, sign in pairs(require('config.icons').dap) do
      sign = type(sign) == 'table' and sign or { sign }

      ---@diagnostic disable-next-line:assign-type-mismatch
      vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
    end
  end,
}
