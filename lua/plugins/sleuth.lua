return {
  'tpope/vim-sleuth',
  config = function()
    local conf = {
      default = {
        indent = 4,
        spaces = false,
      },
      filetype = {
        lua = {
          indent = 2,
          spaces = true,
        },
      },
    }

    local function set_indent(verbose)
      if verbose then
        local tabstop = tonumber(vim.api.nvim_exec2('set ts', { output = true }).output:match('tabstop=([0-9]+)'))
        vim.bo.tabstop = 8 -- Make sure tabstop is 8 before Sleuth runs
        local error = vim.api.nvim_exec2('Sleuth', { output = true }).output:match('Sleuth disabled.*')
        if error then
          print(error)
          vim.bo.tabstop = tabstop
          return
        end
      end
      local shiftwidth = tonumber(vim.api.nvim_exec2('set sw', { output = true }).output:match('shiftwidth=([0-9]+)'))
      local detected = shiftwidth ~= 8 and shiftwidth > 0
      if not detected then
        if conf.filetype[vim.bo.filetype] ~= nil then
          vim.bo.shiftwidth = conf.filetype[vim.bo.filetype].indent or conf.default.indent
          vim.bo.expandtab = conf.filetype[vim.bo.filetype].spaces or conf.default.spaces
        else
          vim.bo.shiftwidth = conf.default.indent
          vim.bo.expandtab = conf.default.spaces
        end
        vim.bo.tabstop = vim.bo.shiftwidth
      else
        vim.bo.tabstop = shiftwidth
      end

      if verbose then
        local message
        if detected then
          message = 'sleuth: set'
        else
          message = 'default: set'
        end
        if vim.bo.expandtab then
          message = message .. ' et'
        else
          message = message .. ' noet'
        end
        print(message .. ' sw=' .. vim.bo.tabstop .. ' ts=' .. vim.bo.tabstop)
      end
    end

    vim.api.nvim_create_user_command('Indent', function()
      set_indent(true)
    end, {})

    -- Set initial indentation
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost', 'BufFilePost', 'FileType' }, {
      group = vim.api.nvim_create_augroup('custom-sleuth', { clear = true }),
      callback = function()
        vim.defer_fn(function() -- Defer because it fails otherwise
          local values = vim.api.nvim_exec2('set sw ts sts', { output = true }).output
          local shiftwidth = tonumber(values:match('shiftwidth=([0-9]+)'))
          local tabstop = tonumber(values:match('tabstop=([0-9]+)'))
          local softtabstop = tonumber(values:match('softtabstop=(-?[0-9]+)'))
          if softtabstop ~= -1 then
            vim.bo.softtabstop = -1
          end
          if shiftwidth ~= 8 or tabstop ~= 8 then -- Indent already set
            if shiftwidth ~= tabstop then
              if vim.bo.expandtab then
                vim.bo.tabstop = shiftwidth
              else
                vim.bo.shiftwidth = tabstop
              end
            end
            return
          end
          set_indent()
        end, 100)
      end,
    })
  end,
}
