return { -- Highlight comments with specified keywords
	"folke/todo-comments.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" }, -- Required
	config = function()
		local comments = require("todo-comments")
		local icons = require("config.icons").comments

		comments.setup({
			signs = false,
			keywords = {
				FIX = { icon = icons.fix, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = icons.todo, color = "info" },
				HACK = { icon = icons.hack, color = "warning" },
				WARN = { icon = icons.warn, color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = icons.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = icons.note, color = "hint", alt = { "INFO" } },
				TEST = { icon = icons.test, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		})
	end,
}
