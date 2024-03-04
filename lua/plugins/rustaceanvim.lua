return {
  'mrcjkb/rustaceanvim',
  version = '^3', -- Recommended
  ft = { 'rust' },
  event = 'VeryLazy',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
    {
      'lvimuser/lsp-inlayhints.nvim',
      opts = {},
    },
  },
  config = function()
    vim.g.rustaceanvim = {
      -- inlay_hints = {
      -- highlight = "NonText",
      -- },
      tools = {
        hover_actions = {
          auto_focus = true,
        },
      },
      server = {
        on_attach = function(client, bufnr)
          require('lsp-inlayhints').on_attach(client, bufnr)
          vim.keymap.set('n', '<leader>ca', function()
            vim.cmd.RustLsp 'codeAction'
          end, { silent = true, buffer = bufnr, description = '[C]ode [A]ction' })
        end,
      },
    }
  end,
}
