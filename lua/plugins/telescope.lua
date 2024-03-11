return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim', -- Requires ripgrep, fd-find
  branch = '0.1.x',
  event = 'UIEnter',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required
    'nvim-tree/nvim-web-devicons', -- Better icons
    'nvim-treesitter/nvim-treesitter', -- Finder & preview

    'nvim-telescope/telescope-ui-select.nvim', -- Set vim.ui.select to telescope

    { -- If encountering errors, see telescope-fzf-native README for install instructions
      'nvim-telescope/telescope-fzf-native.nvim', -- Fuzzy finder

      -- Make telescope-fzf-native when installing or updatings
      build = 'make',

      -- Only use make if is available in the system
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },

    'folke/which-key.nvim', -- Show keymaps
  },
  config = function()
    require('which-key').register({
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    })

    local actions = require('telescope.actions')
    local action_layout = require('telescope.actions.layout')
    local previewers = require('telescope.previewers')
    local Job = require('plenary.job')
    local new_maker = function(filepath, bufnr, opts)
      filepath = vim.fn.expand(filepath)
      Job:new({
        command = 'file',
        args = { '--mime-type', '-b', filepath },
        on_exit = function(j)
          local mime_type = vim.split(j:result()[1], '/')[1]
          if mime_type == 'text' then
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          else
            -- maybe we want to write something to the buffer here
            vim.schedule(function()
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY' })
            end)
          end
        end,
      }):sync()
    end

    -- Setup ui-select
    require('telescope').setup({
      defaults = {
        buffer_previewer_maker = new_maker,
        preview = {
          filesize_limit = 0.1, -- MB
        },
        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<M-p>'] = action_layout.toggle_preview,
          },
        },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--trim', -- add this value
        },
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ['<c-d>'] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    -- Enable telescope extensions, if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      })
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
