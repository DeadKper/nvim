local has_treesitter, treesitter = pcall(require, "nvim-treesitter.configs")
if not has_treesitter then
	return
end

---@diagnostic disable-next-line:missing-fields
treesitter.setup({
	ensure_installed = {},
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})
