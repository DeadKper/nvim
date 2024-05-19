local has_mason, mason = pcall(require, "mason")
if not has_mason then
	return
end

-- Config mason
mason.setup()
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

vim.filetype.add({ extension = { templ = 'templ' } }) -- Add templ as a file extension

-- Config mason-lspconfig
local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason")
if has_mason_lspconfig then
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
					runtime = { version = 'LuaJIT' },
					completion = {
						callSnippet = 'Replace',
					},
				},
			},
		},
	}

	-- Make lsp capabilities
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- Setup mason lspconfig
	mason_lspconfig.setup({
		handlers = {
			function(server_name)
				-- List of default servers and their configs
				local server = servers[server_name] or {}

				-- This handles overriding only values explicitly passed by the server configuration above
				server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
				require('lspconfig')[server_name].setup(server)
			end,
		},
	})
end
