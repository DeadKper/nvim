return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim", -- Requires ripgrep, fd-find
	branch = "0.1.x",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required
		"nvim-tree/nvim-web-devicons", -- Better icons
		"nvim-treesitter/nvim-treesitter", -- Finder & preview

		"nvim-telescope/telescope-ui-select.nvim", -- Set vim.ui.select to telescope

		{ -- If encountering errors, see telescope-fzf-native README for install instructions
			"nvim-telescope/telescope-fzf-native.nvim", -- Fuzzy finder

			-- Make telescope-fzf-native when installing or updatings
			build = "make",

			-- Only use make if is available in the system
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function() end,
}
