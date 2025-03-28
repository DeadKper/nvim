return { -- File tree on the side
	"sindrets/diffview.nvim",
	cond = not vim.g.vscode,
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	},
	config = {
		view = {
			merge_tool = {
				layout = "diff3_mixed",
			},
		},
		hooks = {
			diff_buf_read = function(bufnr)
				vim.opt_local.wrap = false
				vim.opt_local.list = false
			end,
		},
	},
}
