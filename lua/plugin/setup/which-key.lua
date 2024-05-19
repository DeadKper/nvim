local has_wk, wk = pcall(require, "which-key")
if not has_wk then
	return
end

local wkconf = require("plugin.confs.which-key")
wkconf.loaded = true

-- Document existing key chains
wkconf.add({
	["<leader>d"] = "which_key_ignore",
	["<leader>y"] = "which_key_ignore",
	["<leader>f"] = { name = "[F]iles", _ = "which_key_ignore" },
	["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
})

wk.setup(wkconf.get())
