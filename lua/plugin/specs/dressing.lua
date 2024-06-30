return {
	"stevearc/dressing.nvim",
	cond = vim.g.noiceui and not vim.g.vscode,
	event = "VeryLazy",
	opts = {},
}
