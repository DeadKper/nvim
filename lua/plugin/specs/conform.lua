return { -- Formatter
	"stevearc/conform.nvim",
	event = "VeryLazy",
	config = function()
		require("plugin.setup.conform")
	end,
}
