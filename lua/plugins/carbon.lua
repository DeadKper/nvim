return {
	"DeadKper/carbon.nvim",
	-- dir = "~/Documents/Codes/lua/carbon.nvim/",
	lazy = false,
	priority = 999,
	config = function()
		---@type carbon.Config
		local opts = {
			overrides = {
				colors = {
					background = "NONE",
				},
			},
		}

		require("carbon").setup(opts)
		vim.cmd.colorscheme("carbon")
	end,
}
