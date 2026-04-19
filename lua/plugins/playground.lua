return {
	"nvim-treesitter/playground",
	cond = function()
		return vim.fn.has("nvim-0.12") == 0
	end,
	event = "VeryLazy",
}
