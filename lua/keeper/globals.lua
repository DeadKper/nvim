-- Custom status column display
vim.g.statuscolumn = {
	display = { "nums", { "fclse", "signs", "gitsg", "fopen", "marks" } },
	nums_cond = true,
	rnupad = true,
}

-- Enable this to use local theme and disable noice
vim.g.dev = false

-- Temp mark used in keymaps, won't be shown in status column
vim.g.temp_mark = "p"

-- Explore filesystem command
vim.g.explore = "Ex"

-- Better ui
vim.g.noiceui = true

-- Indentation guides
vim.g.indent = false

-- Default bufferline type
vim.g.bufferline = "tabs"

-- [ Don't change anything below here ] --

vim.g.noiceui = vim.g.noiceui and not vim.g.dev
