return { -- LSP configuration
  'neovim/nvim-lspconfig',
  lazy = true, -- Loaded in mason.lua
  dependencies = {
    { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP
    'folke/which-key.nvim', -- Show keymaps
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        require('which-key').register({
          ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
          ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
          ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
          ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        })

        -- Easily define mappings specific for LSP related items
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local telescope = require('telescope.builtin')

        -- Jump to the definition of the word under your cursor.
        --  To jump back, press <C-T>.
        map('gd', telescope.lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', telescope.lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', telescope.lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find al the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace
        --  Similar to document symbols, except searches over your whole project.
        map('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Opens a popup that displays documentation about the word under your cursor
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Show diagnostics
        map('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          -- Highlight word under cursor
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          -- Remove word highlight
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- Set diagnostics icons
    for name, icon in pairs(require('config.icons').diagnostics) do
      name = 'DiagnosticSign' .. name:sub(1, 1):upper() .. name:sub(2)
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
    end
  end,
}
