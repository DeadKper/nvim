return { -- Autoclose common pairs like ', ", (, [, {, `, ...
	"echasnovski/mini.pairs",
	event = "VeryLazy",
	opts = {
		mappings = {
			["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
		},
	},
}
