return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  ft = { 'rust' },
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
    local utils = require 'utils'
    table.insert(utils.loaded_languages, 'rust')
    local conf_file = utils.find_config()
    if conf_file ~= nil then
      vim.cmd(':luafile ' .. conf_file)
    end
    vim.g.rustaceanvim = {
      inlay_hints = {
        highlight = 'NonText',
      },
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
          end, { silent = true, buffer = bufnr, description = 'LSP: [C]ode [A]ction' })
        end,
      },
    }
  end,
}
