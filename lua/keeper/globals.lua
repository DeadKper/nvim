-- Custom status column display
vim.g.statuscolumn = {
	display = { "nums", { "fclse", "signs", "gitsg", "fopen", "marks" } },
	nums_cond = true,
	rnupad = 1,
}

-- Temp mark used in keymaps, won't be shown in status column
vim.g.temp_mark = "p"

-- Explore filesystem command
vim.g.explore = "Ex"

-- Better ui
vim.g.noiceui = 1
