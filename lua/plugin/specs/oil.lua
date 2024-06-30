return { -- Better explore
	"stevearc/oil.nvim",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({ view_options = { show_hidden = true } })
		vim.g.explore = "Oil"
		if vim.bo.filetype == "netrw" then
			vim.defer_fn(function()
				vim.cmd("Oil")
			end, 50)
		end
	end,
}
