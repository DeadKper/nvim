return { -- Better move selection
	"echasnovski/mini.move",
	event = "VeryLazy",
	opts = {
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
	},
}
