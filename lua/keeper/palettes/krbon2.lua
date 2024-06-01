local diff = {
	add = "#122F2F",
	change = "#222A39",
	text = "#2F3F5C",
	delete = "#361C28",
}

local krbon = {
	grey00 = "#161616",
	grey01 = "#1D1D1D",
	grey02 = "#404040",
	grey03 = "#5C5C5C",
	grey04 = "#D5D5D5",
	grey05 = "#EAEAEA",
	grey06 = "#FFFFFF",

	base00 = "#08BDBA",
	base01 = "#3DDBD9",
	base02 = "#78A9FF",
	base03 = "#EE5396",
	base04 = "#33B1FF",
	base05 = "#FF7EB6",
	base06 = "#42BE65",
	base07 = "#BE95FF",
	base08 = "#82CFFF",

	diffad = "#122F2F",
	diffch = "#222A39",
	difftx = "#2F3F5C",
	diffdl = "#361C28",
}

local c = {
	normal = krbon.grey05,
	border = krbon.grey03,
	decoration = krbon.base00,
	hidden = krbon.grey03,
	built_in = krbon.base01,
	var_name = krbon.grey05,
	func_name = krbon.base03,
	type_name = krbon.base04,
	key = krbon.base03,
	val = krbon.base04,
	parameter = krbon.base05,
	string = krbon.base06,
	operator = krbon.base00,
	success = krbon.base05,
	warning = krbon.base00,
	info = krbon.base03,
	error = krbon.base01,
	background = krbon.grey00,
	background_hl = krbon.grey01,
	float_background = krbon.grey00,
}

require("keeper.colors").apply({
	ColorColumn = { bg = c.background_hl },
	Conceal = { fg = c.hidden },
	Normal = { fg = c.normal, bg = c.background },
	NormalFloat = { fg = c.normal, bg = c.float_background },
})
