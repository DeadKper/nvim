return { -- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("plugin.confs.lualine")
	end,
}
