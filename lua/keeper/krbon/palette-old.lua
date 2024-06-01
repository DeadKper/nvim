local blend = require("keeper.krbon.util").blend

local white = "#FFFFFF"
local black = "#000000"

---@alias KrbonColors table<string, string>
return {
	accent = "#9134CC",

	bg0 = blend(black, white, 0.04),
	bg1 = blend(black, white, 0.08),
	bg2 = blend(black, white, 0.12),
	bg3 = blend(black, white, 0.16),

	fg0 = blend(black, white, 0.80),
	fg1 = blend(black, white, 0.40),
	fg2 = blend(black, white, 0.36),
	fg3 = blend(black, white, 0.32),

	none = "NONE",
	reddish_blue = "#78A9FF",
	salmon_pink = "#EE5396",
	blue = "#33B1FF",
	pink = "#FF7EB6",
	emerald = "#42BE65",
	lavender = "#BE95FF",
	cyan = "#08BDBA",
	light_cyan = "#3DDBD9",
	light_blue = "#95D6FF",
	light_green = "#90E39A",
	light_red = "#FF6B6C",
	light_yellow = "#FDFD96",
	dark_green = "#122F2F",
	dark_blue = "#222A39",
	dark_grey = "#2F3F5C",
	dark_red = "#361C28",
}
