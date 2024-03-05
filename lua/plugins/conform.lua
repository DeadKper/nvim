return { -- Autoformat
  'stevearc/conform.nvim',
  event = 'VimEnter',
  config = function()
    local conform = require 'conform'
    conform.setup {
      notify_on_error = false,
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
      formatters_by_ft = {
        lua = { 'stylua' },
        sql = { 'sqlfmt' },
        fish = { 'fish_indent' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
      formatters = {
        fish_indent = {
          command = 'fish_indent',
        }
      }
    }
    vim.keymap.set('n', '<leader>ff', function()
      conform.format { lsp_fallback = true, timeout_ms = 500 }
    end, { desc = '[F]ile [F]ormat' })
  end,
}
