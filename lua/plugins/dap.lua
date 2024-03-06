-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  ft = { 'java', 'go' },
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-jdtls',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    ---@diagnostic disable-next-line:missing-fields
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    local function start()
      local conf = vim.fs.find({ '.nvim-dap.lua', '.nvim-dap', '.nvim' }, {
        upward = true,
        stop = vim.loop.os_homedir(),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })

      if next(conf) == nil then
        local types = {}
        for _, value in pairs(vim.lsp.get_active_clients()) do
          for _, v in pairs(value.config.filetypes) do
            table.insert(types, v)
          end
        end

        if next(types) ~= nil then
          local root_markers = {
            ['java'] = {
              'settings.gradle',
              'settings.gradle.kts',
              'pom.xml',
              'build.gradle',
              'build.gradle.kts',
              'mvnw',
              'gradlew',
              '.git',
            },
          }

          for _, value in pairs(types) do
            if root_markers[value] ~= nil then
              ---@type table|string
              local root = vim.fs.find(root_markers[value], {
                upward = true,
                stop = vim.loop.os_homedir(),
                path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
              })

              ---@diagnostic disable-next-line:param-type-mismatch
              if next(root) == nil then
                local res = vim.loop.cwd()
                if res ~= nil then
                  root = res
                end
              else
                root = vim.fs.dirname(root[1])
              end

              vim.fn.system {
                'mkdir',
                root .. '/.nvim',
              }

              vim.fn.system {
                'cp',
                vim.fn.stdpath 'config' .. '/lua/debug/' .. value .. '.lua',
                root .. '/.nvim/nvim-dap.lua',
              }
              break
            end
          end
        end
      end

      for _, conf_file in ipairs({ "./.nvim-dap/nvim-dap.lua", "./.nvim-dap.lua", "./.nvim/nvim-dap.lua" }) do
        local file = io.open(conf_file)
        if file ~= nil then
          file:close()
          vim.cmd(":luafile " .. conf_file)
          break
        end
      end

      dap.continue()
    end

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', start, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line:missing-fields
    dapui.setup {}

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()
  end,
}
