-- Set mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Disable swapfile in favour of undo history
vim.opt.swapfile = false
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = vim.fn.winheight(0) / 5 + 0.5 > 4 and math.floor(vim.fn.winheight(0) / 5 + 0.5) or 4

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: Make sure your terminal supports this
vim.opt.termguicolors = true

-- Enable wordwrap and break indent
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'shift:2', 'sbr' }

-- Enable smartindent
vim.opt.smartindent = true

-- Disable word highlight
vim.opt.hlsearch = false

-- Enable incremental search
vim.opt.incsearch = true
vim.opt.inccommand = 'nosplit'

-- Sets how neovim will display certain whitespace in the editor
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Set complete options
vim.opt.completeopt = 'menu,menuone,noselect'

-- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.conceallevel = 2

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Set rg as the default grep program if it's installed
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep'
end

-- Set fillchars
local icons = require('config.icons')
local fillchars = {
  eob = ' ',
  foldopen = icons.fold.open,
  foldsep = ' ',
  fold = ' ',
  foldclose = icons.fold.close,
  diff = icons.diff,
}
vim.opt.fillchars = fillchars

-- Set fold config
vim.opt.foldlevel = 99

-- Config custom status column and fold text
if vim.fn.has('nvim-0.9.0') == 1 then
  vim.opt.statuscolumn = [[%!v:lua.require('config.util').statuscolumn()]]
  vim.opt.foldtext = "v:lua.require('config.util').foldtext()"
end
