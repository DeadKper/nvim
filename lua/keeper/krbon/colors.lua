---Return colors
---@return KrbonColors
local function colors()
	return vim.tbl_deep_extend("force", {}, require("keeper.krbon.onedark"), require("keeper.krbon.config").colors)
end

return colors()
