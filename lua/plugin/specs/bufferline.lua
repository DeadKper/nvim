return { -- Buffer line
	"akinsho/bufferline.nvim",
	event = "UIEnter", -- Doesn't work correctly on VeryLazy
	cond = not vim.g.vscode,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = vim.g.noiceui and vim.g.bufferline or "tabs",
				tab_size = 1,
				diagnostics = "nvim_lsp",
				hover = {
					enabled = true,
					delay = 0,
					reveal = { "close" },
				},
			},
		})
		if not vim.g.noiceui or vim.g.bufferline == "tabs" then
			vim.api.nvim_create_autocmd({ "TabClosed" }, {
				group = vim.api.nvim_create_augroup("close-tabline", { clear = true }),
				callback = function()
					vim.defer_fn(function()
						vim.opt.showtabline = 1
					end, 10)
				end,
			})
			vim.opt.showtabline = 1
		end
	end,
}
