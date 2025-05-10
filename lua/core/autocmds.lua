-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Show relative number lines when in insert mode or focus lost
vim.schedule(function()
	local augroup_num_lines = vim.api.nvim_create_augroup("numbered-lines", { clear = true })
	if vim.fn.eval("&nu") == 1 then
		vim.opt_local.relativenumber = true
	end

	vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
		group = augroup_num_lines,
		callback = function()
			if vim.fn.eval("&nu") == 1 and vim.fn.mode() ~= "i" then
				vim.opt_local.relativenumber = true
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
		group = augroup_num_lines,
		callback = function()
			if vim.fn.eval("&nu") == 1 then
				vim.opt_local.relativenumber = false
			end
		end,
	})
end)

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("auto-create-dir", { clear = true }),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end

		---@diagnostic disable-next-line: undefined-field
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("checktime", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"fugitive",
		"git",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", ":close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("json-conceal", { clear = true }),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Set colorcolumn on gitcommit
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit" },
	group = vim.api.nvim_create_augroup("git-colorcolumn", { clear = true }),
	callback = function()
		vim.opt_local.colorcolumn = "50"
	end,
})

-- Set word wrap for filetypes except plain text and no ft
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "", "text", "txt", "log" },
	group = vim.api.nvim_create_augroup("detect-word-wrap", { clear = true }),
	callback = function()
		vim.opt_local.wrap = false
	end,
})

-- Configure terminal window
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("open-terminal", { clear = true }),
	callback = function()
		vim.opt.signcolumn = "no"
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

-- Configure lsp on attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		if vim.g.nerd_font then -- Set diagnostics icons when using nerdfonts
			for name, icon in pairs(require("core.icons").diagnostics) do
				name = "DiagnosticSign" .. name:sub(1, 1):upper() .. name:sub(2)
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
		end

		vim.diagnostic.config({
			virtual_text = {
				source = "if_many",
				prefix = require("core.icons").virtual_text,
			},
			severity_sort = true,
		})

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		vim.opt_local.signcolumn = "yes"

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
			vim.cmd.hi("LspInlayHint guifg=#888888 gui=italic")
		end
	end,
})
