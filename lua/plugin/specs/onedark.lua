return { -- Theme inspired by Atom
	"navarasu/onedark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "warmer",
			-- transparent = vim.g.transparency > 0,
			diagnostics = {
				-- background = false,
			},
			lualine = {
				-- transparent = vim.g.transparency > 0,
			},
			highlights = {
				DashboardHeader = { fg = "#FAC898" },
				DashboardFooter = { fg = "#FF6961" },
			},
		})

		require("keeper.colorscheme").set("onedark", vim.g.transparency > 1)
	end,
}
