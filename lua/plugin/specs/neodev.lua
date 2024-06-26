return { -- Better neovim dev experience
	"folke/neodev.nvim",
	lazy = true,
	cond = not vim.g.vscode,
	init = function()
		require("plugin.confs.mason").ensure("lua-language-server", "stylua")
		require("plugin.confs.treesitter").ensure("vim", "vimdoc")
	end,
}
