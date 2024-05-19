local M = {}

---@type table<string>
M.ensure_installed = {}

---List of parsers to ensure are installed when setting up treesitter
---@param ... string
function M.ensure(...)
	for _, value in ipairs({ ... }) do
		if not vim.tbl_contains(M.ensure_installed, value) then
			table.insert(M.ensure_installed, value)
		end
	end
end

return M
