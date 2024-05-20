return { -- Create a dashboard screen similar to the one in Doom Emacs
	"Shatur/neovim-session-manager",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required
	},
	config = function()
		local config = require("session_manager.config")
		require("session_manager").setup({
			autoload_mode = config.AutoloadMode.Disabled,
		})
	end,
}
