return { -- Automatically install LSPs and related tools to stdpath for neovim
  'williamboman/mason.nvim',
  event = 'UIEnter',
  dependencies = {
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

    -- Add custom filetypes
    vim.filetype.add({ extension = { templ = 'templ' } })

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
    local registry = require('mason-registry')

    registry:on('package:install:success', function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require('lazy.core.handler.event').trigger({
          event = 'FileType',
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    local function ensure_installed()
      for _, tool in ipairs(conf.ensure_installed) do
        local p = registry.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end

    if registry.refresh then
      registry.refresh(ensure_installed)
    else
      ensure_installed()
    end

    local auto_install = {
      c = { 'clangd' },
      cmake = { 'cmake-language-server' },
      cpp = { 'clangd' },
      lua = { 'lua-language-server', 'stylua' },
      go = { 'gopls' },
      templ = { 'templ' },
      html = { 'html-lsp' },
      htmx = { 'htmx-lsp' },
      java = { 'jdtls' },
      javascript = { 'biome' },
      json = { 'biome' },
      markdown = { 'marksman' },
      python = { 'pyright' },
      php = { 'intelephense' },
      rust = { 'rust-analyzer' },
      toml = { 'taplo' },
      typescript = { 'biome' },
    }

    vim.api.nvim_create_autocmd({ 'FileType' }, {
      group = vim.api.nvim_create_augroup('mason-autoinstall', { clear = true }),
      callback = function()
        local tools = auto_install[vim.bo.filetype]

        if tools ~= nil and next(tools) then
          local installed = false
          for _, tool in pairs(tools) do
            local package = registry.get_package(tool)
            if not package:is_installed() then
              package:install()
              installed = true
            end
          end

          if installed then
            print('installing tools for: ' .. vim.bo.filetype)
          end
        end
      end,
    })

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
