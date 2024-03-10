return { -- Automatically install LSPs and related tools to stdpath for neovim
  'williamboman/mason.nvim',
  event = 'UIEnter',
  dependencies = {
    { 'folke/neodev.nvim', opts = {} }, -- Setup lua_ls to have better neovim integration
    'neovim/nvim-lspconfig', -- LSP configuration
    'williamboman/mason-lspconfig.nvim', -- Allow lspconfig integration to mason
  },
  config = function()
    -- Set new neovim capabilities granted by the LSP, requires 'hrsh7th/cmp-nvim-lsp' to be included
    -- in lazy, in this case in cmp.lua
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Setup Mason for automatic LSP, formatters, debuggers install
    --  You can press `g?` for help in :Mason menu
    require('mason').setup()

    -- Server configuration
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }

    -- Setup mason lspconfig
    require('mason-lspconfig').setup({
      ensure_installed = vim.tbl_keys(servers or {}), -- Install configured lsp servers
      handlers = {
        function(server_name)
          -- List of default servers and their configs
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed by the server configuration above
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    })
  end,
}
