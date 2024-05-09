return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    if not vim.g.vscode then
      -- Autoclose common pairs like ', ", (, [, {, ...
      require('mini.pairs').setup()
    end

    -- Move selection, better than keymaps
    require('mini.move').setup({
      mappings = {
        -- Move visual selection in Visual mode
        left = 'H',
        right = 'L',
        down = 'J',
        up = 'K',

        -- Disable mini.move in Normal mode
        line_left = '',
        line_right = '',
        line_down = '',
        line_up = '',
      },
    })
  end,
}
