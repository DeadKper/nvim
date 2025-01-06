return { -- File tree on the side
	"sindrets/diffview.nvim",
	cond = not vim.g.vscode,
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	},
	config = true,
}
