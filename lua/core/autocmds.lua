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
