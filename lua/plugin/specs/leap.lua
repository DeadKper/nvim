return { -- Jump to an occurence fast
	"ggandor/leap.nvim",
	config = function()
		local leap = require("leap")
		leap.setup({})
		vim.keymap.set("n", "<leader>j", "<Plug>(leap)", { desc = "Leap in window" })
		vim.keymap.set("n", "<leader>J", "<Plug>(leap-from-window)", { desc = "Leap from window" })
	end,
}
