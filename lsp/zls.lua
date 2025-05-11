return {
	cmd = { "zls" },
	filetypes = { "zig" },
	root_markers = { ".editorconfig", ".git", ".jj", "build.zig", "build.zig.zon", ".zig-cache" },

	executables = { "zig" },
	mason_packages = { "zls", "codelldb" },
}
