return { -- Better rust-analyzer integration
	"mrcjkb/rustaceanvim",
	ft = { "rust" },
	version = "^4", -- Recommended
	cond = not vim.g.vscode,
	init = function()
		require("plugin.confs.lspconfig").add_ignore("rust_analyzer")
	end,
}
