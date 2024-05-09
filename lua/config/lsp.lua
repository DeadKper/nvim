local ignored = {}
local ensure_installed = {}
local auto_install = {
  c = {
    check = function()
      return vim.fn.executable('gcc') == 1
    end,
    packages = { 'clangd', 'codelldb' },
  },
  cpp = {
    check = function()
      return vim.fn.executable('gcc') == 1
    end,
    packages = { 'clangd', 'codelldb' },
  },
  lua = {
    check = function()
      return vim.fn.executable('lua') == 1 or vim.fn.executable('luajit') == 1
    end,
    packages = { 'lua-language-server', 'stylua' },
  },
  go = {
    check = function()
      return vim.fn.executable('go') == 1
    end,
    packages = { 'gopls' },
  },
  templ = {
    check = function()
      return vim.fn.executable('templ') == 1
    end,
    packages = { 'templ', 'html-lsp', 'htmx-lsp' },
  },
  html = { packages = { 'html-lsp', 'htmx-lsp' } },
  htmx = { packages = { 'htmx-lsp' } },
  java = {
    check = function()
      return vim.fn.executable('java') == 1
    end,
    packages = { 'jdtls' },
  },
  javascript = {
    check = function()
      return vim.fn.executable('node') == 1
    end,
    packages = { 'biome' },
  },
  json = {
    check = function()
      return vim.fn.executable('node') == 1
    end,
    packages = { 'json-lsp', 'biome' },
  },
  markdown = { packages = { 'marksman' } },
  python = {
    check = function()
      return vim.fn.executable('python3') == 1 or vim.fn.executable('python') == 1
    end,
    packages = { 'pyright' },
  },
  php = {
    check = function()
      return vim.fn.executable('composer') == 1
    end,
    packages = { 'intelephense', 'easy-coding-standard' },
  },
  rust = {
    check = function()
      return vim.fn.executable('cargo') == 1
    end,
    packages = { 'rust-analyzer', 'codelldb' },
  },
  toml = { packages = { 'taplo' } },
  typescript = {
    check = function()
      return vim.fn.executable('node') == 1
    end,
    packages = { 'biome' },
  },
  zig = {
    check = function()
      return vim.fn.executable('zig') == 1
    end,
    packages = { 'zls', 'codelldb' },
  },
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
---@return table<string>|nil auto_install returns the list of packages to install when opening a related filetype
function M.get_auto_install(ft)
  local tool = auto_install[ft]
  if tool == nil or tool.check and not tool.check() then
    return nil
  end
  return tool.packages
end

return M
