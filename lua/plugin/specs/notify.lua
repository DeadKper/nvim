return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	cond = vim.g.noiceui and not vim.g.vscode,
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
			---@diagnostic disable-next-line:assign-type-mismatch
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
}
