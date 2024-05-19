local has_onedark, onedark = pcall(require, "onedark")
if not has_onedark then
	return
end

onedark.setup({
	transparent = true,
	diagnostics = {
		background = false,
	},
	lualine = {
		transparent = true,
	},
})

vim.cmd("colorscheme onedark")
