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

    local icons = require('config.icons')
    local indentscope = require('mini.indentscope')
    indentscope.setup({
      symbol = icons.lines.center,
      options = { try_as_border = true },
      draw = {
        delay = 50,
        animation = indentscope.gen_animation.linear({
          duration = 10,
        }),
      },
    })

    local indent = require('config.indent')
    local excludes = {
      filetypes = indent.get_exclude('blankline', 'filetype'),
      buftypes = indent.get_exclude('blankline', 'buftype'),
    }
    local function set_indentscope()
      vim.b.miniindentscope_disable = vim.tbl_contains(excludes.filetypes, vim.bo.filetype)
        or vim.tbl_contains(excludes.buftypes, vim.bo.buftype)
    end
    vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FileType' }, {
      group = vim.api.nvim_create_augroup('mini.indentscope', { clear = true }),
      callback = set_indentscope,
    })
    set_indentscope()
  end,
}
