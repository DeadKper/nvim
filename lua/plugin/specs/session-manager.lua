return { -- Create a dashboard screen similar to the one in Doom Emacs
	"Shatur/neovim-session-manager",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required
	},
	config = function()
		local config = require("session_manager.config")
		local session_manager = require("session_manager")

		session_manager.setup({
			autoload_mode = config.AutoloadMode.Disabled,
		})

		local excludes_ft = {
			"",
			"alpha",
			"checkhealth",
			"dashboard",
			"fugitive",
			"help",
			"lazy",
			"lazyterm",
			"lspinfo",
			"man",
			"mason",
			"neo-tree",
			"notify",
			"oil",
			"packer",
			"TelescopePrompt",
			"TelescopeResults",
			"toggleterm",
			"trouble",
			"Trouble",
			"git",
			"gitcommit",
			"gitrebase",
		}

		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			callback = function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					-- Don't save while there's any 'nofile' buffer open.
					if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
						return
					end
				end
				if vim.tbl_contains(excludes_ft, vim.bo.filetype) then
					return
				end
				session_manager.save_current_session()
			end,
		})
	end,
}
