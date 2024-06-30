return {
	"wfxr/minimap.vim",
	cond = not vim.g.vscode,
	build = (function()
		if vim.fn.executable("cargo") == 0 then
			return
		end
		return "cargo install --locked code-minimap"
	end)(),
}
