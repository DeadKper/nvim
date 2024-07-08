-- Set mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- File explorer
vim.keymap.set("n", "<leader>fe", function()
	vim.cmd(vim.g.explore)
end, { desc = "[F]ile [E]xplorer", silent = true })

-- Move selection
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { silent = true })
vim.keymap.set("v", "L", ">gv")
vim.keymap.set("v", "H", "<gv")

-- Move in insert mode
vim.keymap.set("i", "<C-j>", function()
	vim.cmd("normal j")
end, { silent = true })
vim.keymap.set("i", "<C-k>", function()
	vim.cmd("normal k")
end, { silent = true })
vim.keymap.set("i", "<C-l>", "<Right>", { silent = true })
vim.keymap.set("i", "<C-h>", "<Left>", { silent = true })

-- Move in command mode, lua version is not working
vim.cmd("cnoremap <C-j> <Down>")
vim.cmd("cnoremap <C-k> <Up>")
vim.cmd("cnoremap <C-l> <Right>")
vim.cmd("cnoremap <C-h> <Left>")

-- Move through windows quickly
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })

-- Adjust windows quickly
vim.keymap.set("n", "<M-t>", "<C-w>2+", { silent = true })
vim.keymap.set("n", "<M-s>", "<C-w>2-", { silent = true })
vim.keymap.set("n", "<M-w>", "<C-w>4>", { silent = true })
vim.keymap.set("n", "<M-d>", "<C-w>4<", { silent = true }) -- should be M-s but it's already in use

local scroll_up = "normal! " .. vim.api.nvim_replace_termcodes("<C-y>", true, true, true)
local scroll_dw = "normal! " .. vim.api.nvim_replace_termcodes("<C-e>", true, true, true)
local function adjust_view(do_zz)
	vim.cmd("normal! m" .. vim.g.temp_mark)
	if do_zz == nil or do_zz then
		vim.cmd("normal! zz")
	end

	local prev
	local curr = vim.fn.winline()
	local height = vim.fn.winheight(0)
	local bufend = vim.fn.getpos("$")[2] - vim.fn.getpos(".")[2]

	while prev ~= curr and (height - curr) - bufend > 0 do -- scroll one at a time in case of wrapped lines
		vim.cmd(scroll_up)
		prev = curr
		curr = vim.fn.winline()
	end

	vim.cmd("normal! `" .. vim.g.temp_mark)
	vim.cmd("delm " .. vim.g.temp_mark)

	if vim.g.mini_animate then
		local has_animate, animate = pcall(require, "mini.animate")
		if has_animate then
			pcall(animate.execute_after, "scroll", "")
		end
	end
end
-- Set zz to center view, but don't show buf end lines and don't center on long wrapped lines
vim.keymap.set("n", "zz", adjust_view, { silent = true })

local function jump(keycomb, do_zz)
	local cmd = "normal! " .. vim.api.nvim_replace_termcodes(keycomb, true, true, true)
	return function()
		local curr = vim.fn.getpos(".")[2]
		vim.cmd(cmd)
		if curr == vim.fn.getpos(".")[2] then
			vim.cmd(cmd)
		end
		adjust_view(do_zz)
	end
end
-- Jump half page and center view
vim.keymap.set("n", "<C-u>", jump("<C-u>"), { silent = true })
vim.keymap.set("n", "<C-d>", jump("<C-d>"), { silent = true })

-- Jump a page without scrolling off the end of the buffer
vim.keymap.set("n", "<C-f>", jump("<C-f>", false), { silent = true })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>fy", ":%y+<cr>", { desc = "[F]ile [Y]ank" })

-- Paste over selected contents without overriding " register
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("x", "<leader>P", '"_dp')

-- Paste from system clipboard
vim.keymap.set({ "n", "i", "v" }, "<M-p>", function()
	vim.cmd('normal! "+p')
end)
vim.keymap.set({ "n", "i", "v" }, "<M-S-P>", function()
	vim.cmd('normal! "+P')
end)

-- Delete without saving contents to a delete register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- C-c does weird stuff sometimes
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Buffer keymaps
vim.keymap.set("n", "<C-n>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<C-p>", ":bprevious<cr>", { silent = true })
vim.keymap.set("n", "<C-q>", ":bdelete<cr>", { silent = true })

-- Rename word
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename word" })

-- Macro editor
vim.keymap.set(
	"n",
	"<leader>m",
	":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
	{ silent = true, desc = "Edit current macro buffer" }
)

local function custom_n(expr)
	return function()
		if pcall(vim.api.nvim_exec2, "normal! " .. vim.fn.eval(expr), { output = false }) then
			adjust_view()
		end
	end
end

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", custom_n("'Nn'[v:searchforward].'zv'"), { desc = "Next Search Result" })
vim.keymap.set("x", "n", custom_n("'Nn'[v:searchforward]"), { desc = "Next Search Result" })
vim.keymap.set("o", "n", custom_n("'Nn'[v:searchforward]"), { desc = "Next Search Result" })
vim.keymap.set("n", "N", custom_n("'nN'[v:searchforward].'zv'"), { desc = "Prev Search Result" })
vim.keymap.set("x", "N", custom_n("'nN'[v:searchforward]"), { desc = "Prev Search Result" })
vim.keymap.set("o", "N", custom_n("'nN'[v:searchforward]"), { desc = "Prev Search Result" })

require("plugin.confs.which-key").add({
	["<leader><tab>"] = { name = "Tabs" },
})
-- Tab keymaps
vim.keymap.set("n", "<leader><tab><tab>", ":tabnew<cr>", { desc = "New tab", silent = true })
vim.keymap.set("n", "<leader><tab>q", ":tabclose<cr>", { desc = "Close tab", silent = true })
vim.keymap.set("n", "<leader><tab>n", ":tabnext<cr>", { desc = "[N]ext tab", silent = true })
vim.keymap.set("n", "<leader><tab>p", ":tabprev<cr>", { desc = "[P]revious tab", silent = true })

-- Marks are not latin american layout friendly
vim.keymap.set("n", "|", "`")

-- Quick replace
vim.keymap.set("n", ";", ":%s///g<left><left><left>")
vim.keymap.set("v", ";", ":s///g<left><left><left>")
