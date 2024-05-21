return { -- Harpoon for fast navigation
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" }, -- Required
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({})

		local mappings = {
			["<leader>h"] = { name = "[H]arpoon", _ = "which_key_ignore" },
			["<leader>h#"] = { desc = "[H]arpoon jump to file [#]" },
		}
		for i = 1, 10, 1 do
			---@diagnostic disable-next-line:assign-type-mismatch
			mappings["<leader>h" .. i % 10] = "which_key_ignore"
		end
		require("plugin.confs.which-key").add(mappings)

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]ppend" })

		vim.keymap.set("n", "<leader>hf", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon [F]iles" })

		for i = 1, 10, 1 do
			vim.keymap.set("n", "<leader>h" .. i % 10, function()
				harpoon:list():select(i)
			end)
		end
	end,
}
