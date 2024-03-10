return { -- Automatically install LSPs and related tools to stdpath for neovim
  'williamboman/mason.nvim',
  event = 'UIEnter',
  dependencies = {
    'neovim/nvim-lspconfig', -- LSP configuration
    'williamboman/mason-lspconfig.nvim', -- Allow lspconfig integration to mason
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- Auto install formatters
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

    local conf = require('plugins.lsps.conf')

    conf.auto_install(vim.tbl_keys(servers))

    require('mason-tool-installer').setup({
      ensure_installed = conf.mason_ensure_installed,
    })

    -- Auto-install and update after 1 second, mason-tools-installer won't autoinstall if lazy loaded
    vim.defer_fn(function()
      vim.cmd([[MasonToolsUpdate]])
    end, 1000)

    -- Setup mason lspconfig
    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          -- Don't setup ignore servers
          if vim.tbl_contains(conf.ignore_lspconfig, server_name) then
            return
          end

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
