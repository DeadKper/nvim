---@class KrbonConfigAccent
---@field color string color to use as accent, defaults to #9134CC
---@field enabled boolean enable accent color to be used
---@field highlight boolean use accent to also highlight selections, matching parents, string search, etc...
---@field foreground boolean use highlight in foreground instead of background where possible

---@class KrbonConfigDiagnostics
---@field darker boolean darker colors for diagnostic

---@class KrbonConfig
---@field transparent boolean set or not Normal background
---@field float_transparent boolean set or not NormalFloat background
---@field term_colors boolean enable terminal colors
---@field cmp_itemkind_reverse boolean reverse item kind highlights in cmp menu
---@field ending_tildes boolean reverse item kind highlights in cmp menu
---@field accent KrbonConfigAccent accent config
---@field colors KrbonColors override default colors
---@field highlights KrbonHighlight override highlight groups
---@field diagnostics KrbonConfigDiagnostics diagnostic configs
local M = {
	-- Main options

	transparent = false,
	float_transparent = false,
	term_colors = true,
	cmp_itemkind_reverse = false,
	ending_tildes = false,

	-- Accent options

	accent = {
		color = "#9134CC",
		enabled = false,
		highlight = false,
		foreground = false,
	},

	-- Custom Highlights

	colors = {},
	highlights = {},

	-- Plugins Related

	diagnostics = {
		darker = true,
	},
}

return M
