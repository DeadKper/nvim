return {
	"folke/snacks.nvim",
	event = "UIEnter",
	---@diagnostic disable-next-line: undefined-doc-name
	---@type snacks.Config
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	opts = {
		bigfile = { enable = true },
		image = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = {
			enabled = true,
			left = { "mark", "sign" }, -- priority of signs on the left (high to low)
			right = { "fold", "git" }, -- priority of signs on the right (high to low)
		},
	},
}
