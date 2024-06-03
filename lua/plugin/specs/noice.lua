return {
	"folke/noice.nvim",
	event = "VeryLazy",
	cond = vim.g.noiceui,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
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
			view = "cmdline_popup", -- cmdline
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
					win_options = { conceallevel = 3 },
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
