local ok, plugin = pcall(require, "oil")
if not ok then
	return
end

plugin.setup({ view_options = { show_hidden = true } })
vim.g.explore = "Oil"
