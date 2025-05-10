return { -- Automatically install LSPs and related tools to stdpath for neovim
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"mfussenegger/nvim-dap", -- Debug configuration
		"jay-babu/mason-nvim-dap.nvim", -- Allow dap integration to mason
	},
	config = function()
		require("mason").setup()

		local registry = require("mason-registry")
		local to_install = 0
		local skip_next_ammount = 0

		registry:on("package:install:success", function()
			to_install = to_install - 1

			if to_install == 0 then
				vim.defer_fn(function()
					skip_next_ammount = skip_next_ammount + 1
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end
		end)

		local lsp_conf = {}
		local lsp_filetypes = {}

		for _, lsp in pairs(vim.split(vim.fn.glob(vim.fn.stdpath("config") .. "/lsp/*.lua"), "\n", { trimempty = true })) do
			local conf = dofile(lsp)

			for _, ft in ipairs(conf.filetypes) do
				lsp_filetypes[#lsp_filetypes + 1] = ft

				lsp_conf[ft] = {
					executables = conf.executables,
					mason_packages = conf.mason_packages,
				}

				vim.lsp.enable(lsp:match("lsp/(.+)%.lua$"))
			end
		end

		--- @diagnostic disable-next-line:missing-fields
		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = lsp_filetypes,
			group = vim.api.nvim_create_augroup("mason-autoinstall", { clear = true }),
			callback = function()
				if skip_next_ammount > 0 then
					skip_next_ammount = skip_next_ammount - 1
					return
				end

				local conf = lsp_conf[vim.bo.filetype]

				local executables = conf.executables

				if type(executables) == "string" then
					executables = { executables }
				end

				local total = #executables
				local count = 0

				--- @diagnostic disable-next-line: redefined-local
				for _, executables in ipairs(executables) do
					if type(executables) == "string" then
						--- @diagnostic disable-next-line: cast-local-type
						executables = { executables }
					end

					for _, exec in ipairs(executables) do
						if vim.fn.executable(exec) == 1 then
							count = count + 1
							break
						end
					end
				end

				if count == total then
					for _, mason_package in ipairs(conf.mason_packages) do
						local package = registry.get_package(mason_package)

						if not package:is_installed() then
							package:install()
							to_install = to_install + 1
						end
					end
				end
			end,
		})

		-- Trigger FileType event to load lsps or autoinstall if needed
		require("lazy.core.handler.event").trigger({
			event = "FileType",
			buf = vim.api.nvim_get_current_buf(),
		})
	end,
}
