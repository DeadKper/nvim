return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	build = ":TSUpdate",
	config = function()
		require("plugin.setup.treesitter")
	end,
}
