return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"neovim/nvim-lspconfig",

		"folke/neoconf.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		require("mason").setup()

		local registry = require("mason-registry")
		local to_install = 0
		local skip_next_ammount = 0

		registry:on("package:install:success", function()
			to_install = to_install - 1

			if to_install == 0 then
				vim.defer_fn(function()
					skip_next_ammount = skip_next_ammount + 1

					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end
		end)

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", {}, capabilities, require("blink.cmp").get_lsp_capabilities())
		capabilities = vim.tbl_deep_extend("force", {}, capabilities, {
			textDocument = {
				foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
			},
		})

		vim.lsp.config("*", {
			capabilities = capabilities,
			root_markers = { ".editorconfig", ".git", ".jj" },
		})

		local lspconfig = require("core.lspconfig")
		lspconfig.enable_lsps()

		vim.api.nvim_create_autocmd("FileType", {
			pattern = lspconfig.get_filetypes(),
			group = vim.api.nvim_create_augroup("mason-autoinstall", { clear = true }),
			callback = function()
				if skip_next_ammount > 0 then
					skip_next_ammount = skip_next_ammount - 1
					return
				end

				for _, mason_package in ipairs(lspconfig.get_mason_packages(vim.bo.filetype)) do
					local package = registry.get_package(mason_package)

					if not package:is_installed() then
						package:install()
						to_install = to_install + 1
					end
				end
			end,
		})

		require("lazy.core.handler.event").trigger({
			event = "FileType",
			buf = vim.api.nvim_get_current_buf(),
		})
	end,
}
