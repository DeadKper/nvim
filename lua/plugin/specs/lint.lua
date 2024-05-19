return { -- Run linters
	"mfussenegger/nvim-lint",
	event = "VeryLazy",
	config = function()
		require("plugin.setup.lint")
	end,
}
