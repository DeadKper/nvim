return { -- List to show diagnostics, references, quickfixes and more
	"folke/trouble.nvim",
	event = "VeryLazy",
	cond = not vim.g.vscode,
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- Enable file icons
	},
	config = function()
		require("plugin.confs.which-key").add({
			["<leader>t"] = { name = "[T]rouble", _ = "which_key_ignore" },
		})

		require("trouble").setup({
			use_diagnostic_signs = true,
		})

		local ok, _ = pcall(require, "todo-comments")
		if ok then
			vim.keymap.set("n", "<leader>tc", ":TodoTrouble<cr>", { desc = "[T]rouble todo [C]omments", silent = true })
		end

		local last_mode = "Trouble diagnostics toggle"

		local function toggle(str)
			if str ~= nil then
				str = "Trouble " .. str
				return function()
					last_mode = str
					vim.cmd(str)
				end
			else
				return function()
					vim.cmd(last_mode)
				end
			end
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("trouble-lsp-attach", { clear = true }),
			once = true,
			callback = function()
				vim.keymap.set("n", "<leader>tt", toggle(), { desc = "[T]rouble [T]oggle" })
				vim.keymap.set(
					"n",
					"<leader>tb",
					toggle("diagnostics toggle filter.buf=0"),
					{ desc = "[T]rouble [B]uffer diagnostics" }
				)
				vim.keymap.set("n", "<leader>td", toggle("diagnostics toggle"), { desc = "[T]rouble [D]iagnostics" })
				vim.keymap.set("n", "<leader>tq", toggle("qflist toggle"), { desc = "[T]rouble [Q]uickfix" })
				vim.keymap.set("n", "<leader>tl", toggle("loclist toggle"), { desc = "[T]rouble [L]ocation list" })
				vim.keymap.set("n", "<leader>tr", toggle("lsp toggle"), { desc = "[T]rouble LSP [R]eferences" })
			end,
		})
	end,
}
