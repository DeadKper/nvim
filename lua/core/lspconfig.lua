local M = {}

---@class core.lspconfig.package
---@field [1] string
---@field reqs nil|string|table<string>|table<table<string>>

---@class core.lspconfig
---@field enabled nil|boolean
---@field ft string|table<string>
---@field lsp nil|string|core.lspconfig.package
---@field formatter nil|string|core.lspconfig.package
---@field linter nil|string|core.lspconfig.package
---@field debugger nil|string|core.lspconfig.package

---@type table<string, core.lspconfig>
M.config = {
	lua_ls = {
		ft = "lua",
		lsp = "lua-language-server",
		formatter = "stylua",
	},
	marksman = {
		ft = "markdown",
		lsp = "marksman",
	},
	rust_analyzer = {
		ft = "rust",
		lsp = "rust-analyzer",
		debugger = "codelldb",
	},
	taplo = {
		ft = "toml",
		lsp = "taplo",
	},
	zls = {
		ft = "zig",
		lsp = "zsl",
		debugger = "codelldb",
	},
}
---@param reqs table<string>|table<table<string>>
---@return boolean
local check_reqs_helper = function(reqs)
	if reqs == nil then
		return true
	end

	local count = 0

	for _, value in ipairs(reqs) do
		if type(value) == "table" then
			for _, req in ipairs(value) do
				if vim.fn.executable(req) then
					count = count + 1
					break
				end
			end
		elseif type(value) == "string" then
			if vim.fn.executable(value) then
				count = count + 1
			end
		else
			count = count + 1
		end
	end

	return #reqs == count
end

---@param data string|core.lspconfig.package
---@return any
local get_valid_packages = function(data)
	if type(data) == "string" then
		return data
	elseif type(data) == "table" then
		if data.reqs == nil then
			return data[1]
		elseif type(data.reqs) == "string" then
			return check_reqs_helper({ data.reqs }) and data[1]
		elseif type(data.reqs) == "table" then
			return check_reqs_helper(data.reqs) and data[1] ---@diagnostic disable-line: param-type-mismatch
		end
	end

	return nil
end

---@param ft string
---@return table<string>
function M.get_mason_packages(ft)
	local packages = {}

	for _, value in pairs(M.config) do
		local ftypes = value.ft
		if type(ftypes) == "string" then
			ftypes = { value.ft }
		end
		if vim.tbl_contains(ftypes, ft) then
			packages[#packages + 1] = get_valid_packages(value.lsp)
			packages[#packages + 1] = get_valid_packages(value.formatter)
			packages[#packages + 1] = get_valid_packages(value.linter)
			packages[#packages + 1] = get_valid_packages(value.debugger)
		end
	end

	return packages
end

---@return table<string>
function M.get_filetypes()
	local fts = {}
	for _, value in pairs(M.config) do
		if type(value.ft) == "string" then
			fts[#fts + 1] = value.ft
		else
			for _, val in ipairs(value.ft) do ---@diagnostic disable-line: param-type-mismatch
				fts[#fts + 1] = val
			end
		end
	end
	return fts
end

function M.enable_lsps()
	local to_enable = {}
	for key, value in pairs(M.config) do
		if value.enabled == nil or value.enabled then
			to_enable[#to_enable + 1] = key
		end
	end
	if #to_enable > 0 then
		vim.lsp.enable(to_enable)
	end
end

return M
