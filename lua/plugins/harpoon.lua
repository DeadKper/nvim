return { -- Harpoon for fast navigation
  'ThePrimeagen/harpoon',
  event = 'VeryLazy',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required
    'nvim-telescope/telescope.nvim', -- Search through harpoon buffer list
    'folke/which-key.nvim', -- Show keymaps
  },
  config = function()
    local mappings = {
      ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
      ['<leader>h#'] = { desc = '[H]arpoon jump to file [#]' },
    }
    for i = 1, 10, 1 do
      ---@diagnostic disable-next-line:assign-type-mismatch
      mappings['<leader>h' .. i % 10] = 'which_key_ignore'
    end
    require('which-key').register(mappings)

    local harpoon = require('harpoon')
    harpoon:setup({})

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon [A]ppend' })

    vim.keymap.set('n', '<leader>hf', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon [F]iles' })

    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function telescope_picker()
      local file_paths = {}
      for _, item in ipairs(harpoon:list().items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end
    vim.keymap.set('n', '<leader>hs', telescope_picker, { desc = '[H]arpoon [S]earch' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<M-p>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<M-n>', function()
      harpoon:list():next()
    end)

    for i = 1, 10, 1 do
      vim.keymap.set('n', '<leader>h' .. i % 10, function()
        harpoon:list():select(i)
      end)
    end
  end,
}
