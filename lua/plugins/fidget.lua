return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		notification = {
			window = {
				winblend = string.match(vim.api.nvim_exec2("hi Normal", { output = true }).output, "guibg") and 0 or 100,
			},
		},
	},
}
