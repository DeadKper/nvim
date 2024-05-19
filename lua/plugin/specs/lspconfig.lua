return { -- LSP configuration
	"neovim/nvim-lspconfig",
	lazy = true, -- Load this on mason
	dependencies = {
		{ "j-hui/fidget.nvim", opts = {} }, -- Useful status updates for LSP
	},
	config = function()
		require("plugin.setup.lspconfig")
	end,
}
