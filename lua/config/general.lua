vim.filetype.add({
	extension = {
		templ = "templ",
		kbd = "lisp",
		tmux = "tmux",
		jinja = "jinja",
		jinja2 = "jinja",
		j2 = "jinja",
	},
})

vim.api.nvim_create_user_command("ToggleColumn", function()
	if vim.fn.eval("&nu") == 1 then
		vim.opt.signcolumn = "no"
		vim.opt.number = false
		vim.opt.relativenumber = false
	else
		vim.opt.signcolumn = "yes"
		vim.opt.number = true
		vim.opt.relativenumber = true
	end
end, {})
