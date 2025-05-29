require("core.global")
require("core.options")
require("core.keymaps")
require("core.autocmds")
if vim.fn.has("nvim-0.11") == 1 then
	require("core.lsp")
end
if vim.fn.has("nvim-0.10") == 1 then
	require("core.lazy")
end
