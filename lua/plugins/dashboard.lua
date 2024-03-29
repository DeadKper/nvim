return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-telescope/telescope.nvim', -- Search through files
    'nvim-tree/nvim-web-devicons', -- Better icons
    'Shatur/neovim-session-manager',
  },
  config = function()
    local logo = [[
██████╗ ███████╗ █████╗ ██████╗ ██╗  ██╗██████╗ ███████╗██████╗ 
██╔══██╗██╔════╝██╔══██╗██╔══██╗██║ ██╔╝██╔══██╗██╔════╝██╔══██╗
██║  ██║█████╗  ███████║██║  ██║█████╔╝ ██████╔╝█████╗  ██████╔╝
██║  ██║██╔══╝  ██╔══██║██║  ██║██╔═██╗ ██╔═══╝ ██╔══╝  ██╔══██╗
██████╔╝███████╗██║  ██║██████╔╝██║  ██╗██║     ███████╗██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
    ]]

    logo = string.rep('\n', 5) .. logo .. '\n'

    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, '\n'),
        center = {
          { action = 'Telescope find_files', desc = ' Find file', icon = ' ', key = 'f' },
          { action = 'Ex', desc = ' File explorer', icon = ' ', key = 'e' },
          { action = 'ene | startinsert', desc = ' New file', icon = ' ', key = 'n' },
          { action = 'Telescope oldfiles', desc = ' Recent files', icon = ' ', key = 'r' },
          { action = 'Telescope live_grep', desc = ' Find text', icon = ' ', key = 'g' },
          { action = [[lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })]], desc = ' Config', icon = ' ', key = 'c' },
          { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
        },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        end,
      },
    }

    local n = #opts.config.center
    table.insert(opts.config.center, n, { icon = ' ', key = 's' })
    if vim.loop.cwd() == vim.loop.os_homedir() then
      opts.config.center[n].action = 'SessionManager load_last_session'
      opts.config.center[n].desc = ' Restore last session'
    else
      opts.config.center[n].action = 'SessionManager load_current_dir_session'
      opts.config.center[n].desc = ' Restore session'
    end

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      button.key_format = '  %s'
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'DashboardLoaded',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    require('dashboard').setup(opts)
  end,
}
