-- Better mark usage for la-latin1 keys
vim.keymap.set("n", "|", function()
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes("`", true, true, true))
end)

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Don't move cursor doing "J"
vim.keymap.set("n", "J", function()
	vim.cmd("normal! m" .. vim.g.temp_mark .. "J`" .. vim.g.temp_mark)
	vim.api.nvim_buf_del_mark(vim.api.nvim_get_current_buf(), vim.g.temp_mark)
end)

-- File explorer
vim.keymap.set("n", "<leader>fe", function()
	vim.cmd(vim.g.file_explorer)
end, { desc = "[F]ile [E]xplorer" })

-- Make current file executable
vim.keymap.set("n", "<leader>fx", ":!chmod +x %<CR>", { desc = "[F]ile grant e[X]ecute" })

-- Copy file path to clipboard
vim.keymap.set("n", "<leader>fp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "[F]ile [P]ath to clipboard" })

-- Move selection
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up", silent = true })
vim.keymap.set("v", "L", ">gv", { desc = "Increase selection indent", silent = true })
vim.keymap.set("v", "H", "<gv", { desc = "Decrease selection indent", silent = true })

-- Move in insert mode
vim.keymap.set("i", "<C-j>", function()
	vim.cmd("normal j")
end)
vim.keymap.set("i", "<C-k>", function()
	vim.cmd("normal k")
end)
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-h>", "<Left>")

-- Move in command mode, lua version is not working
vim.cmd("cnoremap <C-j> <Down>")
vim.cmd("cnoremap <C-k> <Up>")
vim.cmd("cnoremap <C-l> <Right>")
vim.cmd("cnoremap <C-h> <Left>")

-- Move through windows quickly
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")

-- Adjust windows quickly
vim.keymap.set("n", "<M-t>", "<C-w>2+")
vim.keymap.set("n", "<M-s>", "<C-w>2-")
vim.keymap.set("n", "<M-w>", "<C-w>4>")
vim.keymap.set("n", "<M-d>", "<C-w>4<") -- should be M-s but it's already in use

-- Scroll helper
local scroll_up = "normal! " .. vim.api.nvim_replace_termcodes("<C-y>", true, true, true)

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
vim.keymap.set("n", "<C-u>", jump("<C-u>"))
vim.keymap.set("n", "<C-d>", jump("<C-d>"))

-- Jump a page without scrolling off the end of the buffer
vim.keymap.set("n", "<C-f>", jump("<C-f>", false))
vim.keymap.set("n", "<C-b>", jump("<C-b>", false))

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "[Y]ank to system clipboard" })
vim.keymap.set("n", "<leader>fy", ":%y+<cr>", { desc = "[F]ile [Y]ank", silent = true })

-- Paste over selected contents without overriding " register
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("x", "<leader>P", '"_dp')

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })

-- Paste from system clipboard
vim.keymap.set({ "n", "i", "v" }, "<M-p>", function()
	vim.cmd('normal! "+p')
end)
vim.keymap.set({ "n", "i", "v" }, "<M-S-P>", function()
	vim.cmd('normal! "+P')
end)

-- Delete without saving contents to a delete register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "[D]elete to void buffer" })

-- Set C-c as Esc
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear highlight with C-c", silent = true })

-- Rename word
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename word" })

-- Macro editor
vim.keymap.set(
	"n",
	"<leader>m",
	":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>",
	{ desc = "Edit current macro buffer" }
)

-- Execute "normal!" and "zz"
local function custom_n(expr)
	return function()
		if pcall(vim.api.nvim_exec2, "normal! " .. vim.fn.eval(expr), { output = false }) then
			adjust_view()
		end
	end
end

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", custom_n("'Nn'[v:searchforward].'zv'"), { desc = "Next Search Result" })
vim.keymap.set({ "x", "o" }, "n", custom_n("'Nn'[v:searchforward]"), { desc = "Next Search Result" })
vim.keymap.set("n", "N", custom_n("'nN'[v:searchforward].'zv'"), { desc = "Previous Search Result" })
vim.keymap.set({ "x", "o" }, "N", custom_n("'nN'[v:searchforward]"), { desc = "Previous Search Result" })

-- Tab keymaps
vim.keymap.set("n", "<leader><tab><tab>", ":tabnew<cr>", { desc = "New tab", silent = true })
vim.keymap.set("n", "<leader><tab>q", ":tabclose<cr>", { desc = "Close tab", silent = true })
vim.keymap.set("n", "<leader><tab>n", ":tabnext<cr>", { desc = "[N]ext tab", silent = true })
vim.keymap.set("n", "<leader><tab>p", ":tabprev<cr>", { desc = "[P]revious tab", silent = true })

-- Quick terminal
local term_buf = -1

vim.keymap.set("n", "<leader>qq", function()
	local height = math.min(math.max(math.floor(vim.fn.winheight(0) / 3), 8), 16)

	if not vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd.vnew()
		vim.cmd.term()
		vim.cmd.wincmd("J")
		term_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_win_set_height(0, height)
		vim.cmd.normal("a")
		vim.opt_local.spell = false

		-- Exit terminal with <C-q>
		vim.keymap.set("n", "<C-q>", function()
			vim.cmd(":exit!<cr>")
			adjust_view()
		end, { buffer = term_buf, silent = true })
	else
		vim.cmd.vnew()
		vim.cmd.wincmd("J")
		vim.api.nvim_win_set_height(0, height)
		vim.api.nvim_set_current_buf(term_buf)
		vim.cmd.normal("a")
	end
end, { desc = "[Q]uick Terminal" })

-- Exit terminal insert mode with <C-q>
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]])
