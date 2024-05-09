local ignored = {}
local ensure_installed = {}
local auto_install = {
  c = { 'clangd', 'codelldb' },
  cmake = { 'cmake-language-server' },
  cpp = { 'clangd', 'codelldb' },
  lua = { 'lua-language-server', 'stylua' },
  go = { 'gopls' },
  templ = { 'templ', 'html-lsp', 'htmx-lsp' },
  html = { 'html-lsp', 'htmx-lsp' },
  htmx = { 'htmx-lsp' },
  java = { 'jdtls' },
  javascript = { 'biome' },
  json = { 'json-lsp', 'biome' },
  markdown = { 'marksman' },
  python = { 'pyright' },
  php = { 'intelephense', 'easy-coding-standard' },
  rust = { 'rust-analyzer', 'codelldb' },
  toml = { 'taplo' },
  typescript = { 'biome' },
  zig = { 'zls', 'codelldb' },
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

local M = {}

---@param lsp string|table<string> lsp to add to ignore list for automatic setup in lspconfig
-- Adds a lsp to the ignore list if it's not already being ignored, useful to setup plugins
-- that already setup the server like nvim-jdtls or rustaceanvim
function M.add_ignore(lsp)
  insert_if_missing(ignored, lsp)
end

---@param lsp string lsp to check if should be ignored for automatic setup in lspconfig
---@return boolean
-- Check if a lsp is in the ignore list
function M.is_ignored(lsp)
  return vim.tbl_contains(ignored, lsp)
end

---@param mason_package string|table<string> package to install if missing
-- Mason packages to ensure are installed
function M.add_ensure_install(mason_package)
  insert_if_missing(ensure_installed, mason_package)
end

---@return table<string> ensure_installed returns the list of packages to ensure are installed
function M.get_ensure_installed()
  return ensure_installed
end

---@param ft string filetype to check which packages should be auto installed
---@return table<string> auto_install returns the list of packages to install when opening a related filetype
function M.get_auto_install(ft)
  return auto_install[ft]
end

return M
