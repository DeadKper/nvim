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
}
