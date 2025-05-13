return {
	"folke/snacks.nvim",
	event = "UIEnter",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("snacks").setup({
			bigfile = { enable = true },
			image = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = {
				enabled = true,
				left = {}, -- no sign, always "  "
				right = { "sign", "fold", "git" },
			},
		})

		local stc = require("snacks.statuscolumn")
		local stc_get = stc._get
		function stc._get() -- remove left column
			return stc_get():gsub("  +", "", 1)
		end
	end,
}
