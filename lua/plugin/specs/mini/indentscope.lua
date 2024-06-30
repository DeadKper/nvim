return { -- Add indentation guides on blank lines
	"echasnovski/mini.indentscope",
	cond = require("plugin.confs.indent-guides").enable and not vim.g.vscode,
	event = "VeryLazy",
	config = function()
		local indentscope = require("mini.indentscope")
		local icons = require("config.icons")
		indentscope.setup({
			symbol = icons.other.indent,
			options = { try_as_border = true },
			draw = {
				delay = 50,
				animation = indentscope.gen_animation.linear({
					duration = 10,
				}),
			},
		})

		local excludes = require("plugin.confs.indent-guides").get_exclude("indent")

		local function set_indentscope()
			vim.b.miniindentscope_disable = vim.tbl_contains(excludes.filetypes, vim.bo.filetype)
				or vim.tbl_contains(excludes.buftypes, vim.bo.buftype)
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType" }, {
			group = vim.api.nvim_create_augroup("mini.indentscope", { clear = true }),
			callback = set_indentscope,
		})
		set_indentscope()
	end,
}
