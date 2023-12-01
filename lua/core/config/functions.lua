local M = {}
function M.send_keys(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, true)
end

function M.colorscheme(theme, opts)
  local color = require(theme)
  color.setup(opts)
  color.load()
end
return M
