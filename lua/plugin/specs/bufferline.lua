return { -- Buffer line
	"akinsho/bufferline.nvim",
	event = "UIEnter", -- Doesn't work correctly on VeryLazy
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				tab_size = 1,
				diagnostics = "nvim_lsp",
				hover = {
					enabled = true,
					delay = 0,
					reveal = { "close" },
				},
			},
		})
	end,
}
