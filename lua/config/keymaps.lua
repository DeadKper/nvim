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

-- Move in insertmode
vim.keymap.set("i", "<C-j>", function()
	vim.cmd("normal j")
end, { silent = true })
vim.keymap.set("i", "<C-k>", function()
	vim.cmd("normal k")
end, { silent = true })
vim.keymap.set("i", "<C-l>", "<Right>", { silent = true })
vim.keymap.set("i", "<C-h>", "<Left>", { silent = true })

-- Move through windows quickly
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })

-- Adjust windows quickly
vim.keymap.set("n", "<M-t>", "<C-w>+", { silent = true })
vim.keymap.set("n", "<M-s>", "<C-w>-", { silent = true })
vim.keymap.set("n", "<M-w>", "<C-w>5>", { silent = true })
vim.keymap.set("n", "<M-d>", "<C-w>5<", { silent = true }) -- should be M-s but it's already in use

local scroll_up = "normal! " .. vim.api.nvim_replace_termcodes("<C-y>", true, true, true)
local function custom_zz()
	vim.cmd("normal! m" .. vim.g.temp_mark)
	vim.cmd("normal! zz")

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

	local has_animate, animate = pcall(require, "mini.animate")
	if has_animate then
		animate.execute_after("scroll", "")
	end
end
-- Set zz to center view, but don't show buf end lines and don't center on long wrapped lines
vim.keymap.set("n", "zz", custom_zz, { silent = true })

local function jump(keycomb)
	return function()
		vim.cmd("normal! " .. vim.api.nvim_replace_termcodes(keycomb, true, true, true))
		vim.cmd("normal zz")
	end
end
-- Jump half page and center view
vim.keymap.set("n", "<C-u>", jump("<C-u>"), { silent = true })
vim.keymap.set("n", "<C-d>", jump("<C-d>"), { silent = true })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>fy", ":%y+<cr>", { desc = "[F]ile [Y]ank" })

-- Paste over selected contents without overriding " register
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("x", "<leader>P", '"_dp')

-- Delete without saving contents to a delete register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- C-c does weird stuff sometimes
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Switch between open buffers
vim.keymap.set("n", "<S-l>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<S-h>", ":bprev<cr>", { silent = true })

-- Rename word
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename word" })

-- Macro editor
vim.keymap.set(
	"n",
	"<leader>m",
	":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
	{ silent = true, desc = "Edit current macro buffer" }
)
