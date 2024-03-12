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

    local lsp_mappings = {
      lua = 'lua-language-server',
      java = 'jdtls',
      python = 'pyright',
      rust = 'rust-analyzer',
      toml = 'taplo',
      php = 'intelephense',
      html = 'html-lsp',
      c = 'clangd',
      cpp = 'clangd',
      awk = 'awk-language-server',
      bash = 'bash-language-server',
      cmake = 'cmake-language-server',
      csharp = 'csharp-language-server',
      docker = 'docker-compose-language-service',
      go = 'gopls',
      gradle = 'gradle-language-server',
      groovy = 'graphql-language-service-cli',
      htmx = 'htmx-lsp',
      json = 'json-lsp',
      kotlin = 'kotlin-language-server',
      markdown = 'marksman',
      powershell = 'powershell-editor-services',
      typescript = 'typescript-language-server',
    }

    local conf = require('plugins.lsps.conf')

    conf.auto_install(vim.tbl_keys(servers))

    local tools = require('mason-tool-installer')
    tools.setup({ ensure_installed = conf.mason_ensure_installed })

    local registry = require('mason-registry')
    local mason_busy = false

    vim.api.nvim_create_autocmd({ 'FileType' }, {
      group = vim.api.nvim_create_augroup('mason-autoinstall', { clear = true }),
      callback = function()
        local server = lsp_mappings[vim.bo.filetype]
        if not server or mason_busy or registry.is_installed(server) then
          return
        end

        registry:on(
          'package:handle',
          vim.schedule_wrap(function()
            print(string.format('Installing "%s"', server))
            vim.defer_fn(vim.cmd.close, 5)
          end)
        )

        registry:on(
          'package:install:success',
          vim.schedule_wrap(function()
            mason_busy = false
            print(string.format('Successfully installed "%s"', server))

            vim.defer_fn(function()
              vim.cmd([[LspStart]])
            end, 50)
          end)
        )

        mason_busy = true
        vim.cmd([[MasonInstall ]] .. server)
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
