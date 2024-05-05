return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- This is not supported in many windows environments
        if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },

    { -- Add Codeium as an AI assistant
      'Exafunction/codeium.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      opts = {},
    },

    'saadparwaiz1/cmp_luasnip', -- LuaSnip completion source for nvim-cmp

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      mapping = cmp.mapping.preset.insert({
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Accept the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-e>'] = cmp.mapping.confirm({ select = true }),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete({}),

        -- Go forward on each of the expansion locations
        ['<C-f>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        -- Go backward on each of the expansion locations
        ['<C-b>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'codeium' },
      },
    })
  end,
}
