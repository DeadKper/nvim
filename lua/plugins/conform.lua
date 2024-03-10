return { -- Formatter
  'stevearc/conform.nvim',
  event = 'UIEnter',
  dependencies = {
    'williamboman/mason.nvim', -- Required by mason-tool-installer
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- Auto install formatters
  },
  config = function()
    local conform = require('conform')

    conform.setup({
      notify_on_error = false,
      formatters_by_ft = { -- Setup formatters
        lua = { 'stylua' },
      },
    })

    -- Configure formatters to install
    require('mason-tool-installer').setup({
      ensure_installed = {
        'stylua',
      },
    })

    -- Auto-install formatters after 1 second
    vim.defer_fn(function()
      vim.cmd([[MasonToolsUpdate]])
    end, 1000)

    -- Keymap to format current buffer with LSP fallback
    vim.keymap.set('n', '<leader>ff', function()
      conform.format({ lsp_fallback = true, timeout_ms = 500 })
    end, { desc = '[F]ile [F]ormat' })

    -- Custom autoformat
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.lua' },
      group = vim.api.nvim_create_augroup('autoformat', { clear = true }),
      callback = function()
        conform.format({ lsp_fallback = true, timeout_ms = 500 })
      end,
    })
  end,
}
