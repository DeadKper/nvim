-- Configure lsp on attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		vim.opt_local.signcolumn = "yes"

		if vim.g.nerd_font then -- Set diagnostics icons when using nerdfonts
			local icons = require("core.icons")
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
						[vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
						[vim.diagnostic.severity.INFO] = icons.diagnostics.info,
						[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
					},
				},
			})
		end

		vim.diagnostic.config({
			virtual_text = {
				source = "if_many",
				prefix = require("core.icons").lsp.virtual_text,
			},
			severity_sort = true,
		})

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("<leader>e", vim.diagnostic.open_float, "Show diagnostic [E]rror messages")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local has_telescope, telescope = pcall(require, "telescope.builtin")
		if has_telescope then
			map("gd", function()
				telescope.lsp_definitions({ show_line = false })
			end, "[G]oto [D]efinition")
			-- Jump to the definition of the word under your cursor.
			--  To jump back, press <C-T>.
			map("gd", telescope.lsp_definitions, "[G]oto [D]efinition")

			-- Find references for the word under your cursor.
			map("gr", telescope.lsp_references, "[G]oto [R]eferences")

			-- Jump to the implementation of the word under your cursor.
			--  Useful when your language has ways of declaring types without an actual implementation.
			map("gI", telescope.lsp_implementations, "[G]oto [I]mplementation")

			-- Jump to the type of the word under your cursor.
			--  Useful when you're not sure what type a variable is and you want to see
			--  the definition of its *type*, not where it was *defined*.
			map("<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")

			-- Fuzzy find al the symbols in your current document.
			--  Symbols are things like variables, functions, types, etc.
			map("<leader>S", telescope.lsp_document_symbols, "Document [S]ymbols")

			-- Fuzzy find all the symbols in your current workspace
			--  Similar to document symbols, except searches over your whole project.
			map("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client == nil then
			return
		end

		if client.server_capabilities.documentHighlightProvider then
			-- Highlight word under cursor
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			-- Remove word highlight
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if vim.fn.has("nvim-0.10") and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true)
		end
	end,
})
