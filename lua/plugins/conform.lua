return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>ff",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat [F]ile",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local exclude_filetypes = { "c", "cpp" }
			if vim.tbl_contains(exclude_filetypes, vim.bo[bufnr].filetype) then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = require("core.masonconf").formatters_by_ft(),
	},
}
