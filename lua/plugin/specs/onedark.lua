return { -- Theme inspired by Atom
	"navarasu/onedark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "warmer",
			highlights = {
				DashboardHeader = { fg = "#FAC898" },
				DashboardFooter = { fg = "#FF6961" },
			},
		})

		require("keeper.colors").set("onedark")
	end,
}
