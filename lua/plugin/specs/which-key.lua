return { -- Useful plugin to show you pending keybinds
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.opt.timeout = true
		vim.opt.timeoutlen = 300
	end,
	config = function()
		local wkconf = require("plugin.confs.which-key")
		wkconf.loaded = true

		-- Document existing key chains
		wkconf.add({
			["<leader>d"] = "which_key_ignore",
			["<leader>y"] = "which_key_ignore",
			["<leader>f"] = { name = "[F]iles", _ = "which_key_ignore" },
			["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
		})

		wkconf.register()
	end,
}
