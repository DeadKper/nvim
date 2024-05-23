return { -- Jump to an occurence fast
	"ggandor/leap.nvim",
	event = "VeryLazy",
	config = function()
		local leap = require("leap")
		leap.setup({
			safe_labels = "",
			labels = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM",
		})
		vim.keymap.set("n", "<leader>j", "<Plug>(leap)", { desc = "Leap in window" })
		vim.keymap.set("n", "<leader>J", "<Plug>(leap-from-window)", { desc = "Leap from window" })
	end,
}
