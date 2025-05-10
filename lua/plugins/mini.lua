return {
	"echasnovski/mini.nvim",
	event = "VeryLazy",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })

		require("mini.surround").setup()

		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode
				left = "H",
				right = "L",
				down = "J",
				up = "K",

				-- Disable mini.move in Normal mode
				line_left = "",
				line_right = "",
				line_down = "",
				line_up = "",
			},
		})
	end,
}
