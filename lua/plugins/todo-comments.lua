return {
	"folke/todo-comments.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local comments = require("todo-comments")
		local icons = require("core.icons").comments

		comments.setup({
			signs = false,
			keywords = {
				FIX = { icon = vim.g.nerd_font and icons.fix, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = vim.g.nerd_font and icons.todo, color = "info" },
				HACK = { icon = vim.g.nerd_font and icons.hack, color = "warning" },
				WARN = { icon = vim.g.nerd_font and icons.warn, color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = vim.g.nerd_font and icons.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = vim.g.nerd_font and icons.note, color = "hint", alt = { "INFO" } },
				TEST = { icon = vim.g.nerd_font and icons.test, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		})
	end,
}
