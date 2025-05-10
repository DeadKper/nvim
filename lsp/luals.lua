return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".editorconfig", ".git", ".jj", ".luarc.json", ".luarc.jsonc", ".stylua.toml" },

	executables = { { "lua", "luajit" } },
	mason_packages = { "lua-language-server", "stylua" },
}
