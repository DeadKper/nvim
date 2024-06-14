local M = {}

---@type table<string>
---Packages that will be installed automatically when setting up mason
M.ensure_installed = {}

---@class MasonPackage
---@field execs table<string|table<string>> list of all executables to check, or a table to match any executable
---@field packages table<string> mason package names

---@type table<string, MasonPackage>
---Packages that will be installed automatically when setting up mason
M.filetype_install = {
	bash = {
		execs = { "bash", "node" },
		packages = { "bash-language-server", "shellharden" },
	},
	c = {
		execs = { "gcc" },
		packages = { "clangd", "codelldb" },
	},
	cpp = {
		execs = { "gcc" },
		packages = { "clangd", "codelldb" },
	},
	lua = {
		execs = { { "lua", "luajit" } },
		packages = { "lua-language-server", "stylua" },
	},
	go = {
		execs = { "go" },
		packages = { "gopls" },
	},
	templ = {
		execs = { "templ" },
		packages = { "templ", "html-lsp", "htmx-lsp" },
	},
	html = {
		execs = {},
		packages = { "html-lsp", "htmx-lsp" },
	},
	htmx = {
		execs = {},
		packages = { "htmx-lsp" },
	},
	java = {
		execs = { "java" },
		packages = { "jdtls" },
	},
	javascript = {
		execs = { "node" },
		packages = { "biome" },
	},
	json = {
		execs = { "node" },
		packages = { "json-lsp", "biome" },
	},
	markdown = {
		execs = {},
		packages = { "marksman" },
	},
	python = {
		execs = { { "python3", "python" } },
		packages = { "python-lsp-server" },
	},
	php = {
		execs = { "composer" },
		packages = { "intelephense", "easy-coding-standard" },
	},
	rust = {
		execs = { "cargo" },
		packages = { "rust-analyzer", "codelldb" },
	},
	toml = {
		execs = {},
		packages = { "taplo" },
	},
	typescript = {
		execs = { "node" },
		packages = { "biome" },
	},
	zig = {
		execs = { "zig" },
		packages = { "zls", "codelldb" },
	},
}

---Returns a list of packages that should be installed for the given filetype if the execs are available
---@param filetype string
---@return table packages
function M.get_filetype_packages(filetype)
	if filetype == nil or not M.filetype_install[filetype] then
		return {}
	end

	for _, list in ipairs(M.filetype_install[filetype]) do
		if type(list) == "string" then
			list = { list }
		end

		local flag = false
		for _, exec in ipairs(list) do
			if vim.fn.executable(exec) == 1 then
				flag = true
				break
			end
		end

		if not flag then
			return {}
		end
	end

	return M.filetype_install[filetype].packages
end

---List of packages to ensure are installed when setting up mason
---@param ... string
function M.ensure(...)
	for _, value in ipairs({ ... }) do
		if not vim.tbl_contains(M.ensure_installed, value) then
			table.insert(M.ensure_installed, value)
		end
	end
end

return M
