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
    require('which-key').register({
      ['<leader>d'] = { name = '[D]ebug', _ = 'which_key_ignore' },
    })

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { desc = 'Debug: ' .. desc })
    end

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

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    local folds = require('config.icons').fold
    ---@diagnostic disable-next-line:missing-fields
    dapui.setup({
      icons = { expanded = folds.open, collapsed = folds.close, current_frame = folds.close },
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    map('<F5>', dap.continue, 'Start/Continue')
    map('<F1>', dap.step_into, 'Step Into')
    map('<F2>', dap.step_over, 'Step Over')
    map('<F3>', dap.step_out, 'Step Out')
    map('<F4>', dap.close, 'Stop')
    map('<leader>db', dap.toggle_breakpoint, 'Toggle [B]reakpoint')
    map('<leader>dc', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, 'Set [C]onditional breakpoint')
    map('<leader>dt', dapui.toggle, '[T]oggle Interface')
    map('<leader>de', dapui.eval, '[E]val')
    map('<leader>dr', dap.run_to_cursor, '[R]un to cursor')

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
