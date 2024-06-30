return {
	"gorbit99/codewindow.nvim",
	cond = not vim.g.vscode,
	config = function()
		local codewindow = require("codewindow")
		codewindow.setup({
			auto_enable = false,
			minimap_width = 10,
			window_border = "none",
			exclude_filetypes = { "help", "dashboard" },
		})
		vim.api.nvim_create_user_command("Minimap", function()
			codewindow.toggle_minimap()
		end, {})
	end,
}
