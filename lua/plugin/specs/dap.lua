return { -- Debug adapter for neovim
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		"rcarriga/nvim-dap-ui", -- Creates debuger ui
		"nvim-neotest/nvim-nio", -- Dependency
		{ "theHamsta/nvim-dap-virtual-text", opts = {} }, -- Virtual text for the debugger
	},
	config = function()
		require("plugin.setup.dap")
	end,
}
