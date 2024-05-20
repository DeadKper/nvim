return { -- Automatically install LSPs and related tools to stdpath for neovim
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"neovim/nvim-lspconfig", -- LSP configuration
		"williamboman/mason-lspconfig.nvim", -- Allow lspconfig integration to mason

		"mfussenegger/nvim-dap", -- Debug configuration
		"jay-babu/mason-nvim-dap.nvim", -- Allow dap integration to mason
	},
	config = function()
		-- Config mason
		require("mason").setup()

		local mason_conf = require("plugin.confs.mason")
		local registry = require("mason-registry")

		registry:on("package:install:success", function()
			vim.defer_fn(function()
				-- trigger FileType event to possibly load this newly installed LSP server
				require("lazy.core.handler.event").trigger({
					event = "FileType",
					buf = vim.api.nvim_get_current_buf(),
				})
			end, 100)
		end)

		local function install_tools(tbl)
			for _, tool in ipairs(tbl) do
				local package = registry.get_package(tool)
				if not package:is_installed() then
					package:install()
				end
			end
		end

		local function ensure_installed()
			install_tools(mason_conf.ensure_installed)
		end

		if registry.refresh then
			registry.refresh(ensure_installed)
		else
			ensure_installed()
		end

		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("mason-autoinstall", { clear = true }),
			callback = function()
				install_tools(mason_conf.get_filetype_packages(vim.bo.filetype))
			end,
		})

		vim.filetype.add({ extension = { templ = "templ" } }) -- Add templ as a file extension

		-- Config mason-lspconfig
		local has_neoconf, neoconf = pcall(require, "neoconf")
		if has_neoconf then
			neoconf.setup({})
		end

		local has_neodev, neodev = pcall(require, "neodev")
		if has_neodev then
			neodev.setup({})
		end

		-- Server configuration
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
		}

		local lsp = require("plugin.confs.lspconfig")

		-- Setup mason lspconfig
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					-- List of default servers and their configs
					local server = servers[server_name] or {}

					-- This handles overriding only values explicitly passed by the server configuration above
					server.capabilities = vim.tbl_deep_extend("force", lsp.get_server_capabilities(), server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		lsp.run_callbacks()

		---@diagnostic disable-next-line:missing-fields
		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},
		})
	end,
}
