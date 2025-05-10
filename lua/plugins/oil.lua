return {
	"stevearc/oil.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	config = function()
		require("oil").setup({ view_options = { show_hidden = true } })
		vim.g.file_explorer = "Oil"
		if vim.bo.filetype == "netrw" then
			vim.defer_fn(function()
				vim.cmd("Oil")
			end, 50)
		end
	end,
}
