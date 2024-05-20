return { -- Add indent guides on blank lines
	"lukas-reineke/indent-blankline.nvim",
	cond = require("plugin.confs.indent-guides").enable,
	event = "VeryLazy",
	config = function()
		local icons = require("config.icons")
		require("ibl").setup({
			indent = {
				char = icons.other.indent,
				tab_char = icons.other.indent,
				repeat_linebreak = true,
			},
			viewport_buffer = {
				min = 100,
			},
			scope = { enabled = false },
			exclude = require("plugin.confs.indent-guides").get_exclude("indent"),
		})
	end,
}
