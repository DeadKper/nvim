return {
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-completion",
		"kristijanhusak/vim-dadbod-ui",
	},
	cmd = { "DBUI", "DBUIToggle" },
	keys = {
		{ "<leader>du", ":DBUIToggle<cr>", desc = "Toggle dadbod [U]i" },
	},
	init = function()
		require("plugin.confs.which-key").add({
			["<leader>d"] = { name = "[D]adbod", _ = "which_key_ignore" },
		})
	end,
}
