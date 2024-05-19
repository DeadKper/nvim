return { -- Automatically install LSPs and related tools to stdpath for neovim
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
    "neovim/nvim-lspconfig", -- LSP configuration
    "williamboman/mason-lspconfig.nvim", -- Allow lspconfig integration to mason

		"mfussenegger/nvim-dap", -- Debug configuration
		"jay-babu/mason-nvim-dap.nvim" -- Allow dap integration to mason
  },
	config = function()
		require("plugin.setup.mason")
	end,
}
