return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { ".editorconfig", ".git", ".jj", "Cargo.toml", "Cargo.lock", ".cargo" },

	enabled = false, -- rustaceanvim configures this
	executables = { "rustc" },
	mason_packages = { "rust-analyzer", "codelldb" },
}
