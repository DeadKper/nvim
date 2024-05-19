local ok, plugin = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

plugin.setup({
	ensure_installed = {},
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})
