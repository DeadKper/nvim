return { -- Make tabs have their own set of buffers
	"tiagovla/scope.nvim",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	opts = {},
}
