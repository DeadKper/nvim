return { -- Better explore
	"stevearc/oil.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({ view_options = { show_hidden = true } })
		vim.g.explore = "Oil"
	end,
}
