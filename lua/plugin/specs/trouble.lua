return { -- List to show diagnostics, references, quickfixes and more
	"folke/trouble.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- Enable file icons
	},
	config = function()
		require("plugin.confs.which-key").add({
			["<leader>t"] = { name = "[T]rouble", _ = "which_key_ignore" },
		})

		local trouble = require("trouble")
		trouble.setup({
			use_diagnostic_signs = true,
		})

		local ok, _ = pcall(require, "todo-comments")
		if ok then
			vim.keymap.set("n", "<leader>tc", [[:TodoTrouble<cr>]], { desc = "[T]rouble todo [C]omments", silent = true })
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("trouble-lsp-attach", { clear = true }),
			once = true,
			callback = function()
				vim.keymap.set("n", "<leader>tt", function()
					trouble.toggle()
				end, { desc = "[T]rouble [T]oggle" })
				vim.keymap.set("n", "<leader>tw", function()
					trouble.toggle("workspace_diagnostics")
				end, { desc = "[T]rouble toggle [W]orkspace diagnostics" })
				vim.keymap.set("n", "<leader>td", function()
					trouble.toggle("document_diagnostics")
				end, { desc = "[T]rouble toggle [D]ocument diagnostics" })
				vim.keymap.set("n", "<leader>tq", function()
					trouble.toggle("quickfix")
				end, { desc = "[T]rouble toggle [Q]uickfix" })
				vim.keymap.set("n", "<leader>tl", function()
					trouble.toggle("loclist")
				end, { desc = "[T]rouble toggle [L]ocation list" })
				vim.keymap.set("n", "<leader>tr", function()
					trouble.toggle("lsp_references")
				end, { desc = "[T]rouble toggle LSP [R]eferences" })
			end,
		})
	end,
}
