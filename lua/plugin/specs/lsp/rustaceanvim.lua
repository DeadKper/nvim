return { -- Better rust-analyzer integration
	"mrcjkb/rustaceanvim",
	ft = { "rust" },
	version = "^4", -- Recommended
	init = function()
		require("plugin.confs.lspconfig").add_ignore("rust_analyzer")
	end,
}
