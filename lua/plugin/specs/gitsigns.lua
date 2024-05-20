return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	config = function()
		local signs = {}
		for key, value in pairs(require("config.icons").git) do
			signs[key] = { text = value }
		end

		local gitsigns = require("gitsigns")
		gitsigns.setup({
			signs = signs,
			attach_to_untracked = true,
			yadm = {
				enable = true,
			},
			on_attach = function(bufnr)
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				require("plugin.confs.which-key").add({
					["<leader>h"] = { name = "Gitsigns", _ = "which_key_ignore" },
				})

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [S]tage" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset" })
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[H]unk [S]tage" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[H]unk [R]eset" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[S]tage buffer" })
				map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[R]eset Buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review" })
				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "[B]lame line" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git [D]iff" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end, { desc = "Git [D]iff previous commit" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[H]unk [R]eset" })
			end,
		})
	end,
}
