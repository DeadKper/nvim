return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- stylua: ignore
  event = {
		"BufReadPre " .. vim.fn.expand("~/Nextcloud/Apps/Obsidian") .. "/**",
		"BufNewFile " .. vim.fn.expand("~/Nextcloud/Apps/Obsidian") .. "/**",
	},
	dependencies = { "nvim-lua/plenary.nvim" }, -- Required.
	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "Personal",
					path = "~/Nextcloud/Apps/Obsidian/Personal/",
				},
			},
		})
		vim.keymap.set("n", "<leader>sf", vim.cmd.ObsidianQuickSwitch, { desc = "[S]earch [F]iles in obsidian.md" })
		vim.keymap.set("n", "<leader>st", vim.cmd.ObsidianTags, { desc = "[S]earch [T]ags in obsidian.md" })
	end,
}
