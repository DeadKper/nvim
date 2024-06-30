return { -- Configure local proyect settings
	"folke/neoconf.nvim",
	lazy = true,
	cond = not vim.g.vscode,
	init = function()
		require("plugin.confs.mason").ensure("json-lsp")
		require("plugin.confs.treesitter").ensure("jsonc")
	end,
}
