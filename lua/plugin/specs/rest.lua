return { -- Better explore
	"rest-nvim/rest.nvim",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"rest-nvim/tree-sitter-http",
	},
}
