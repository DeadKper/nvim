return { -- Automatically install LSPs and related tools to stdpath for neovim
  'williamboman/mason.nvim',
  event = 'UIEnter',
  dependencies = {
    'neovim/nvim-lspconfig', -- LSP configuration
    'williamboman/mason-lspconfig.nvim', -- Allow lspconfig integration to mason
  },
  config = function ()
    -- Set new neovim capabilities granted by the LSP, requires 'hrsh7th/cmp-nvim-lsp' to be included
    -- in lazy, in this case in cmp.lua
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Setup Mason for automatic LSP, formatters, debuggers install
    --  You can press `g?` for help in :Mason menu
    require('mason').setup()

    -- Setup mason lspconfig
    require('mason-lspconfig').setup {
      automatic_installation = true,
      handlers = {
        function(server_name)
          -- List of default servers and their configs
          local server = {}
          -- This handles overriding only values explicitly passed by the server configuration above
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end
}
