return { -- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Don't show the mode, since it's already in status line
		vim.opt.showmode = false

		local icons = require("config.icons")

		require("lualine").setup({
			options = {
				icons_enabled = true,
				component_separators = icons.other.indent,
				section_separators = "",
				ignore_focus = {
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dapui_stacks",
					"dap-repl",
					"neo-tree",
					"Trouble",
					"qf",
				},
			},
			sections = {
				lualine_b = {
					"branch",
				},
				lualine_c = {
					"filename",
					{
						"diff",
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
				},
				lualine_x = {
					{ "diagnostics", symbols = icons.diagnostics },
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		})
	end,
}
