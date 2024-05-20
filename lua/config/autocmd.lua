-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Show relative number lines when in insert mode
local augroup_num_lines = vim.api.nvim_create_augroup("numbered-lines", { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter" }, {
	group = augroup_num_lines,
	once = true,
	callback = function()
		local function setrnu()
			if vim.fn.eval("&nu") == 1 and vim.fn.mode() ~= "i" then
				vim.opt_local.relativenumber = true
			end
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
			group = augroup_num_lines,
			callback = setrnu,
		})
		setrnu()
	end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = augroup_num_lines,
	callback = function()
		vim.opt_local.relativenumber = false
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("auto-create-dir", { clear = true }),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
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
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
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
local indent_guides = require("plugin.confs.indent-guides")
local excludes = indent_guides.get_exclude("column")
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("colorcolumn", { clear = true }),
	callback = function(args)
		local buf = vim.bo[args.buf]

		if vim.tbl_contains(excludes.filetypes, buf.filetype) or vim.tbl_contains(excludes.buftypes, buf.buftype) then
			vim.opt_local.colorcolumn = ""
		end

		local col = indent_guides.column.buftypes[buf.buftype] or indent_guides.column.filetypes[buf.filetype]
		if col then
			vim.opt_local.colorcolumn = col
		end
	end,
})
