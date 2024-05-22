-- Custom status column display
vim.g.statuscolumn = {
	display = { "nums", { "fclse", "signs", "gitsg", "fopen", "marks" } },
	nums_cond = true,
	rnupad = true,
}

-- Temp mark used in keymaps, won't be shown in status column
vim.g.temp_mark = "p"

-- Explore filesystem command
vim.g.explore = "Ex"

-- Better ui
vim.g.noiceui = true

-- Indentation guides
vim.g.indent = false

-- Use transparencies
vim.g.transparencies = {
	fidget = true,
	lualine = true,
	floating = true,
	background = true,
}

-- Default bufferline type
vim.g.bufferline = "tabs"
