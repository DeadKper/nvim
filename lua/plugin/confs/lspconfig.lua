local M = {}

---List of capabilities to merge
---@type table<lsp.ClientCapabilities|function>
M.capabilities_list = {}

---List of servers to ignore automatic setup
---@type table<string>
M.ignore = {}

---List of servers ignore automatic setup
---@param ... string
function M.add_ignore(...)
	for _, value in ipairs({ ... }) do
		if not vim.tbl_contains(M.ignore, value) then
			table.insert(M.ignore, value)
		end
	end
end

---List of capabilities to add to the merge list, if index is given it will override the capabilities for said index
---@param capabilities lsp.ClientCapabilities|function
---@param index integer|nil
function M.add_capabilities(capabilities, index)
	if index == nil then
		index = #M.capabilities_list
	end

	M.capabilities_list[index] = capabilities

	return index
end

---Returns the capabilities for the given server
---@return lsp.ClientCapabilities capabilities
function M.get_server_capabilities()
	local caps = vim.lsp.protocol.make_client_capabilities()

	for _, value in ipairs(M.capabilities_list) do
		if type(value) == "table" then
			caps = vim.tbl_deep_extend("force", caps, value)
		elseif type(value) == "function" then
			caps = vim.tbl_deep_extend("force", caps, value())
		end
	end

	return caps
end

return M
