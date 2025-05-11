return {
	"folke/noice.nvim",
	event = "VeryLazy",
	cond = vim.g.modern_ui,
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			config = function()
				local notify = require("notify")
				vim.keymap.set("n", "<leader>n", function()
					notify.dismiss({ silent = true, pending = true })
				end, { desc = "Dismiss All Notifications" })

				---@diagnostic disable-next-line:missing-fields
				notify.setup({
					stages = "fade_in_slide_out",
					timeout = 5000,
					render = "wrapped-compact",
					background_colour = "#000000",
					max_height = function()
						return math.floor(vim.o.lines * 0.75)
					end,
					max_width = function()
						return math.floor(vim.o.columns * 0.75)
					end,
					on_open = function(win)
						vim.api.nvim_win_set_config(win, { zindex = 100 })
					end,
				})
			end,
		},
	},
	opts = {
		blocking = false,
		routes = {
			{
				view = "notify",
				filter = { event = "msg_showmode" },
			},
		},
		cmdline = {
			view = "cmdline_popup",
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			progress = {
				enabled = false,
			},
			documentation = {
				view = "hover",
				opts = {
					lang = "markdown",
					replace = true,
					render = "plain",
					format = { "{message}" },
					win_options = { conceallevel = 0 },
				},
			},
		},
		presets = {
			bottom_search = false,
			command_palette = false,
			long_message_to_split = true,
			inc_rename = true,
			lsp_doc_border = true,
		},
	},
}
