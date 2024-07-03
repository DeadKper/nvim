return { -- Create a dashboard screen similar to the one in Doom Emacs
	"nvimdev/dashboard-nvim",
	lazy = false,
	cond = not vim.g.vscode,
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

		local opts = {
			theme = "doom",
			hide = {
				-- this is taken care of by lualine
				-- enabling this messes up the actual laststatus setting after loading a file
				statusline = false,
			},
			config = {
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

		local height = vim.fn.winheight(0)
		local lines = #vim.split(logo, "\n") + (#opts.config.center * 2)

		local footer_padding = math.floor((height - lines) / 3)

		for i = 1, (height - lines - footer_padding - 1) do
			if i % 3 == 0 then
				logo = logo .. "\n"
			else
				logo = "\n" .. logo
			end
		end

		footer_padding = string.rep("\n", footer_padding) ---@diagnostic disable-line:cast-local-type

		opts.config.header = vim.split(logo, "\n")

		opts.config.footer = function()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			local loadtime = require("config.icons").dashboard.loadtime
				.. " Neovim loaded "
				.. stats.loaded
				.. "/"
				.. stats.count
				.. " plugins in "
				.. ms
				.. "ms"

			return vim.split(footer_padding .. loadtime, "\n")
		end

		require("dashboard").setup(opts)
	end,
}
