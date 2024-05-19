local ok, plugin = pcall(require, "onedark")
if not ok then
	return
end

plugin.setup({
	transparent = true,
	diagnostics = {
		background = false,
	},
	lualine = {
		transparent = true,
	},
})

vim.cmd("colorscheme onedark")
