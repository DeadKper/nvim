return { -- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	config = function()
		-- Don't show the mode, since it's already in status line
		vim.opt.showmode = false

		local icons = require("config.icons")

		vim.o.laststatus = vim.g.lualine_laststatus

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
					{ "diagnostics", symbols = icons.diagnostics },
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		})
	end,
}
