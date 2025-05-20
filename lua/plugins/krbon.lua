return {
	"deadkper/krbon.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		---@diagnostic disable:missing-fields
		require("krbon").setup({
			undercurl = vim.fn.executable("wsl.exe") == 0,
			transparent = {
				background = true,
				statusline = true,
			},
			colors = {
				bg0 = "#0b0b0b", -- Night
				bg1 = "#161616", -- Gray 100
				bg2 = "#262626", -- Gray  90
				bg3 = "#292929", -- Gray 100 Hover
			},
		})

		vim.cmd.colorscheme("krbon")
	end,
}
