return { -- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			vim.o.statusline = " "
		else
			vim.o.laststatus = 0
		end
	end,
	config = function()
		vim.opt.showmode = false

		local icons = require("core.icons")

		vim.o.laststatus = vim.g.lualine_laststatus

		local diags = {}

		if vim.g.nerd_font then
			diags = { "diagnostics", symbols = icons.diagnostics }
		else
			diags = { "diagnostics" }
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				ignore_focus = {
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dapui_stacks",
					"dap-repl",
				},
				disabled_filetypes = {
					"dashboard",
					"dbui",
					"neo-tree",
					"netrw",
					"oil",
					"qf",
					"Trouble",
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
					diags,
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		})
	end,
}
