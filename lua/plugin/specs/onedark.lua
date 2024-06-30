return { -- Theme inspired by Atom
	"navarasu/onedark.nvim",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	config = function()
		require("onedark").setup({
			style = "darker",
			transparent = true,
			diagnostics = {
				background = false,
			},
			lualine = {
				transparent = true,
			},
			highlights = {
				FloatTitle = { fg = "$cyan", bg = "$bg1" },
			},
		})
	end,
}
