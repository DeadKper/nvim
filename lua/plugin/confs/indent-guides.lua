local M = {}

---@alias GuideType
---| 'default'
---| 'indent'
---| 'column'

---@alias GuideExcludeType
---| 'buftypes'
---| 'filetypes'

M.enable = false

M.default = {
	---@type table<GuideExcludeType, table<string>>
	exclude = {
		filetypes = {
			"lspinfo",
			"packer",
			"checkhealth",
			"help",
			"man",
			"TelescopePrompt",
			"TelescopeResults",
			"dashboard",
			"fugitive",
			"Trouble",
			"oil",
			"",
		},
		buftypes = {
			"terminal",
			"nofile",
			"quickfix",
			"prompt",
		},
	},
}

---@class GuideColumn
---@field default nil|string
---@field buftypes table<string, nil|string>
---@field filetypes table<string, nil|string>
---@field exclude table<GuideExcludeType, table<string>>
M.column = {
	default = "121",
	filetypes = {
		gitcommit = "51",
	},
	buftypes = {},
	exclude = {
		filetypes = {},
		buftypes = {},
	},
}

M.indent = {
	---@type table<GuideExcludeType, table<string>>
	exclude = {
		filetypes = {
			"gitcommit",
		},
		buftypes = {},
	},
}

local function deep_copy(table)
	local res = {}
	for key, value in pairs(table) do
		res[key] = type(value) == "table" and deep_copy(value) or value
	end
	return res
end

---Get excludes for a type
---@param type GuideType
---@return table<GuideExcludeType, table<string>>
function M.get_exclude(type)
	local excludes = deep_copy(M.default.exclude)

	if type == "default" then
		return excludes
	end

	for _, value in ipairs(M[type].exclude.filetypes) do
		if not vim.tbl_contains(excludes.filetypes, value) then
			excludes.filetypes[#excludes.filetypes + 1] = value
		end
	end

	for _, value in ipairs(M[type].exclude.buftypes) do
		if not vim.tbl_contains(excludes.buftypes, value) then
			excludes.buftypes[#excludes.buftypes + 1] = value
		end
	end

	return excludes
end

return M
