return {
	"romus204/tree-sitter-manager.nvim",
	lazy = false,
	cond = function()
		return vim.fn.executable("tree-sitter") == 1 and vim.fn.has("nvim-0.12") == 1
	end,
	config = function()
		require("tree-sitter-manager").setup({
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = true,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"bash",
				"sh",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"vim",
				"vimdoc",
			},
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
