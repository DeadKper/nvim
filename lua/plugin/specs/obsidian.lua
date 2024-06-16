return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- stylua: ignore
  event = {
    "BufReadPre " .. vim.fn.expand("~/Nextcloud/Apps/Obsidian") .. "/**.md",
    "BufNewFile " .. vim.fn.expand("~/Nextcloud/Apps/Obsidian") .. "/**.md",
  },
	dependencies = { "nvim-lua/plenary.nvim" }, -- Required.
	opts = {
		workspaces = {
			{
				name = "Personal",
				path = "~/Nextcloud/Apps/Obsidian/Personal/",
			},
		},
	},
}
