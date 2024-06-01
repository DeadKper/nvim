local M = {}

function M.colorscheme()
	if not require("keeper.krbon.config").loaded then ---@diagnostic disable-line:undefined-field
		M.setup() ---@diagnostic disable-line:missing-parameter
	end

	vim.cmd.hi("clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	vim.g.colors_name = "krbon"
	vim.o.termguicolors = true
	vim.o.background = "dark"

	require("keeper.krbon.highlights").setup0()
end

---@param config KrbonConfig
function M.setup(config)
	local defaults = require("keeper.krbon.config")

	local function deep_copy(tbl, copy)
		for key, value in pairs(tbl) do
			if copy[key] then
				if type(value) == "table" then
					deep_copy(value, copy[key])
				else
					tbl[key] = copy[key]
				end
			end
		end
	end

	if config then
		deep_copy(defaults, config)
	end

	defaults.loaded = true ---@diagnostic disable-line:inject-field
end

return M
