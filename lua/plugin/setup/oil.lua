local has_oil, oil = pcall(require, "oil")
if not has_oil then
	return
end

oil.setup({ view_options = { show_hidden = true } })
vim.g.explore = "Oil"
