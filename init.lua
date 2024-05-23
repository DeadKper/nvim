require("keeper.globals")
require("config.options")
require("config.keymaps")
require("config.autocmd")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
---@diagnostic disable-next-line:undefined-field
vim.opt.rtp:prepend(lazypath)

local user = vim.api.nvim_exec2("silent !echo $USER | read", { output = true }).output
require("lazy").setup({
	spec = { import = "plugin.specs" },
	dir = "/home/" .. user .. "/.config/themes/nvim/krbon",
	change_detection = { notify = false },
})
