return { -- Create a dashboard screen similar to the one in Doom Emacs
	"nvimdev/dashboard-nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- Better icons
	},
	config = function()
		local logo = [[
██████╗ ███████╗ █████╗ ██████╗ ██╗  ██╗██████╗ ███████╗██████╗ 
██╔══██╗██╔════╝██╔══██╗██╔══██╗██║ ██╔╝██╔══██╗██╔════╝██╔══██╗
██║  ██║█████╗  ███████║██║  ██║█████╔╝ ██████╔╝█████╗  ██████╔╝
██║  ██║██╔══╝  ██╔══██║██║  ██║██╔═██╗ ██╔═══╝ ██╔══╝  ██╔══██╗
██████╔╝███████╗██║  ██║██████╔╝██║  ██╗██║     ███████╗██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
    ]]

		logo = string.rep("\n", 5) .. logo .. "\n\n"

		local opts = {
			theme = "doom",
			hide = {
				-- this is taken care of by lualine
				-- enabling this messes up the actual laststatus setting after loading a file
				statusline = false,
			},
			config = {
				header = vim.split(logo, "\n"),
				center = {
					{
						action = "Telescope find_files",
						desc = " Find file",
						icon = require("config.icons").dashboard.find,
						key = "f",
					},
					{
						action = "lua vim.cmd(vim.g.explore)",
						desc = " File explorer",
						icon = require("config.icons").dashboard.explorer,
						key = "e",
					},
					{
						action = "ene | startinsert",
						desc = " New file",
						icon = require("config.icons").dashboard.newfile,
						key = "n",
					},
					{
						action = "Telescope oldfiles",
						desc = " Recent files",
						icon = require("config.icons").dashboard.oldfiles,
						key = "r",
					},
					{
						action = "Telescope live_grep",
						desc = " Find text",
						icon = require("config.icons").dashboard.grep,
						key = "g",
					},
					{
						action = "lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })",
						desc = " Config",
						icon = require("config.icons").dashboard.config,
						key = "c",
					},
					{ action = "qa", desc = " Quit", icon = require("config.icons").dashboard.exit, key = "q" },
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return {
						require("config.icons").dashboard.loadtime
							.. " Neovim loaded "
							.. stats.loaded
							.. "/"
							.. stats.count
							.. " plugins in "
							.. ms
							.. "ms",
					}
				end,
			},
		}

		local n = #opts.config.center
		table.insert(opts.config.center, n, { icon = require("config.icons").dashboard.lastsession, key = "s" })
		if vim.loop.cwd() == vim.loop.os_homedir() then
			opts.config.center[n].action = "SessionManager load_last_session"
			opts.config.center[n].desc = " Restore last session"
		else
			opts.config.center[n].action = "SessionManager load_current_dir_session"
			opts.config.center[n].desc = " Restore session"
		end

		for _, button in ipairs(opts.config.center) do
			button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
			button.key_format = "  %s"
		end

		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "DashboardLoaded",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("dashboard").setup(opts)
	end,
}
