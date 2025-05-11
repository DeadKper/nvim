local luasnip = require("luasnip")

local sn = luasnip.snippet
local i = luasnip.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	sn(
		{ trig = "fun" },
		fmt("function <>(){\n\t<>\n}", { i(1, "name"), i(0) }, { delimiters = "<>", indent_string = [[\t]] })
	),
}
