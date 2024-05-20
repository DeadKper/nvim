return { -- virt-column for a better colorcolumn
	"lukas-reineke/virt-column.nvim",
	cond = require("plugin.confs.indent-guides").enable,
	event = "VeryLazy",
	config = function()
		local guides = require("plugin.confs.indent-guides")
		local virt_column = require("virt-column")
		virt_column.setup({
			char = require("config.icons").other.column,
			exclude = guides.get_exclude("column"),
		})
	end,
}
