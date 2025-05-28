return {
	"stevearc/oil.nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	config = function()
		require("oil").setup({ view_options = { show_hidden = true } })
		vim.g.file_explorer = "Oil"
		if vim.bo.filetype == "netrw" then
			vim.schedule(function()
				vim.cmd("Oil")
			end)
		end
	end,
}
