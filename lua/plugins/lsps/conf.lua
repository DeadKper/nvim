local M = {
  ---@type table<string>
  ignore_lspconfig = {},
  ---@type table<string>
  ensure_installed = {},
}

local function insert_if_missing(t, value)
  if type(value) ~= 'table' then
    value = { value }
  end
  for _, v in ipairs(value) do
    if not vim.tbl_contains(t, v) then
      table.insert(t, v)
    end
  end
end

---@param lsp string|table<string> lsp to add to ignore list for automatic setup in lspconfig
-- Adds a lsp to the ignore list if it's not already being ignored, useful to setup plugins
-- that already setup the server like nvim-jdtls or rustaceanvim
function M.ignore(lsp)
  insert_if_missing(M.ignore_lspconfig, lsp)
end

---@param mason_package string|table<string> package to install if missing
-- Mason packages to ensure are installed
function M.auto_install(mason_package)
  insert_if_missing(M.ensure_installed, mason_package)
end

return M
