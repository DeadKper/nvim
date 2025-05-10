return {
	"sindrets/diffview.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = {
		view = {
			merge_tool = {
				layout = "diff3_mixed",
			},
		},
		hooks = {
			diff_buf_read = function()
				vim.opt_local.wrap = false
				vim.opt_local.list = false
			end,
		},
	},
}
