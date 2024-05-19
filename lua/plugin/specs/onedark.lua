return { -- Theme inspired by Atom
	"navarasu/onedark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("onedark").setup({
			transparent = true,
			diagnostics = {
				background = false,
			},
			lualine = {
				transparent = true,
			},
		})

		vim.cmd("colorscheme onedark")
	end,
}
