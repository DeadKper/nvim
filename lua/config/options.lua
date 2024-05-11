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

-- Disable eob fill chars
vim.opt.fillchars = { eob = ' ' }
