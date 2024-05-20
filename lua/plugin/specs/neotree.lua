return { -- File tree on the side
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cond = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>fw", "<cmd>Neotree toggle<cr>", desc = "[F]ile tree [W]indow" },
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					visible = true,
				},
			},
		})
	end,
}