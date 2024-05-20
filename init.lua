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

require("lazy").setup({ spec = { import = "plugin.specs" }, change_detection = { notify = false } })
