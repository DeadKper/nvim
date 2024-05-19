local has_lualine, lualine = pcall(require, "lualine")
if not has_lualine then
	return
end

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

local icons = require("config.icons")
lualine.setup({
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
			"qf",
		},
	},
	sections = {
		lualine_b = {
			"branch",
		},
		lualine_c = {
			"filename",
			"diff",
		},
		lualine_x = {
			{ "diagnostics", symbols = icons.diagnostics },
			"encoding",
			"fileformat",
			"filetype",
		},
	},
})
