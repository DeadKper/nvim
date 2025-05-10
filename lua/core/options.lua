-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = false

-- Enable mouse mode
vim.opt.mouse = "a"

-- Set undofile and disable backup and swapfile
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "no"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor (between 4 and 10 based on screen size)
vim.opt.scrolloff = math.min(math.max(math.floor(vim.fn.winheight(0) / 5), 4), 10)

-- Enable 256 color mode NOTE: Make sure your terminal supports this
vim.opt.termguicolors = true

-- Disable wordwrap by default
vim.opt.wrap = false

-- Configure wordwrap and break indent
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { "shift:2", "sbr" }

-- Enable smartindent
vim.opt.smartindent = true

-- Enable word highlight
vim.opt.hlsearch = true

-- Enable incremental search
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Sets how neovim will display certain whitespace in the editor
vim.opt.list = true
vim.opt.listchars = require("core.icons").listchars

-- Set default indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1
vim.opt.expandtab = false

-- Set fold config
vim.opt.foldenable = false

if vim.g.nerd_font then
	local icons = require("core.icons")

	vim.opt.fillchars = {
		eob = " ",
		foldopen = icons.fold.open,
		foldsep = " ",
		fold = " ",
		foldclose = icons.fold.close,
		diff = icons.other.diff,
	}
end

-- Better session restore
vim.opt.sessionoptions = "curdir,folds,buffers,globals,help,tabpages,terminal,winsize"

-- Enable mouse move event
vim.opt.mousemoveevent = true

-- Set default conceal level
vim.opt.conceallevel = 2

-- Dialog prompt instead of failing an operation
vim.opt.confirm = true

-- Configure backspace behaviour
vim.opt.backspace = { "start", "eol", "indent" }

-- Set background color
vim.opt.background = "dark"

-- Allow uncommon file names to show up
vim.opt.isfname:append("@-@")
