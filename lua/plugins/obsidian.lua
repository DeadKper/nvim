return {
	"epwalsh/obsidian.nvim",
	version = "*",
	-- stylua: ignore
  event = {
		"BufReadPre " .. vim.fn.expand("~/Nextcloud/Apps/Obsidian") .. "/**",
		"BufNewFile " .. vim.fn.expand("~/Nextcloud/Apps/Obsidian") .. "/**",
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "Personal",
					path = "~/Nextcloud/Apps/Obsidian/Personal/",
				},
			},
		})

		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({ "<leader>o", group = "[O]bsidian" })
		end

		vim.keymap.set("n", "<leader>oq", vim.cmd.ObsidianQuickSwitch, { desc = "[Q]uick Switch" })
		vim.keymap.set("n", "<leader>ot", vim.cmd.ObsidianTags, { desc = "Search [T]ags" })
		vim.keymap.set("n", "<leader>on", vim.cmd.ObsidianNew, { desc = "New note" })
		vim.keymap.set("n", "<leader>oc", vim.cmd.ObsidianTOC, { desc = "Table of [C]ontents" })
		vim.keymap.set("n", "<leader>os", vim.cmd.ObsidianSearch, { desc = "[S]earch" })
		vim.keymap.set("n", "<leader>or", vim.cmd.ObsidianRename, { desc = "[R]ename current note" })
		vim.keymap.set("n", "<leader>of", vim.cmd.ObsidianFollowLink, { desc = "[F]ollow Link" })
		vim.keymap.set("n", "<leader>ob", vim.cmd.ObsidianBacklinks, { desc = "[B]acklinks" })
		vim.keymap.set("n", "<leader>od", vim.cmd.ObsidianDailies, { desc = "[D]ailies" })
	end,
}
