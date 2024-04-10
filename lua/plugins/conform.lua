return { -- Formatter
  'stevearc/conform.nvim',
  event = 'UIEnter',
  config = function()
    local conform = require('conform')

    conform.setup({
      notify_on_error = false,
      formatters_by_ft = { -- Setup formatters
        lua = { 'stylua' },
        fish = { 'fish_indent' },
        go = { 'gofmt' },
      },
      formatters = { -- Custom formatters
        fish_indent = {
          command = 'fish_indent',
        },
      },
    })

    require('plugins.lsps.conf').auto_install({
      'stylua',
    })

    -- Filetypes to autoformat
    local auto_format = {
      enabled = nil,
      filetype = {
        lua = true,
        fish = true,
        go = true,
      },
    }

    vim.api.nvim_create_user_command('Autoformat', function(data)
      if data.args:match('status') then
        print('global: ' .. tostring(auto_format.enabled) .. ', ' .. vim.bo.filetype .. ': ' .. tostring(auto_format.filetype[vim.bo.filetype]))
      elseif data.args:match('global') then
        auto_format.enabled = not auto_format.enabled
        print('Set global autoformat to: ' .. tostring(auto_format.enabled))
      elseif data.args:match('filetype') then
        auto_format.filetype[vim.bo.filetype] = not auto_format.filetype[vim.bo.filetype]
        print('Set filetype autoformat to: ' .. tostring(auto_format.filetype[vim.bo.filetype]))
      elseif data.args:match('disable_global') then
        auto_format.enabled = nil
        print('Set global autoformat to: ' .. tostring(auto_format.enabled))
      end
    end, {
      nargs = 1,
      complete = function()
        return { 'status', 'global', 'filetype', 'disable_global' }
      end,
    })

    -- Format buffer with = operation as fallbak
    local function format()
      if not conform.format({ lsp_fallback = true, timeout_ms = 500 }) then
        local view = vim.fn.winsaveview()
        vim.cmd([[silent normal gg=G]])
        vim.fn.winrestview(view)
      end
    end

    -- Keymap to format current buffer with LSP fallback
    vim.keymap.set('n', '<leader>ff', format, { desc = '[F]ile [F]ormat' })

    -- Custom autoformat
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('autoformat', { clear = true }),
      callback = function()
        if auto_format.enabled or (auto_format.enabled == nil and auto_format.filetype[vim.bo.filetype]) then
          format()
        end
      end,
    })
  end,
}
