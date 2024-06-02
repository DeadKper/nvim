return { -- Animations
	"echasnovski/mini.animate",
	event = "VeryLazy",
	cond = vim.g.noiceui,
	config = function()
		local animate = require("mini.animate")
		local max_time = 500
		local scroll_time = 7
		local steps = math.floor(max_time / scroll_time)
		if steps > 60 then
			steps = 60
		end
		vim.g.mini_animate = 1
		local linear = animate.gen_timing.linear({ duration = 10, unit = "step" })
		animate.setup({
			cursor = {
				timing = linear,
			},
			scroll = {
				timing = animate.gen_timing.quartic({ duration = scroll_time, unit = "step", easing = "out" }),
				subscroll = animate.gen_subscroll.equal({ max_output_steps = steps }),
			},
			resize = {
				timing = linear,
			},
			open = {
				timing = linear,
			},
			close = {
				timing = linear,
			},
		})
	end,
}
