return {
	"echasnovski/mini.nvim",
	event = "UIEnter",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })

		require("mini.surround").setup()

		require("mini.move").setup({
			mappings = {
				left = "H",
				right = "L",
				down = "J",
				up = "K",

				line_left = "",
				line_right = "",
				line_down = "",
				line_up = "",
			},
		})
	end,
}
