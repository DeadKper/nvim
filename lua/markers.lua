local M = {
  ['java'] = {
    'settings.gradle',
    'settings.gradle.kts',
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'mvnw',
    'gradlew',
    '.git',
  },
  [nil] = {
    '.git'
  },
}

---@param check table|string|nil table of root markers, string indicating the language or nil to check for .git
---@return string|nil root the root of the project or nil if not found
function M.find_root(check)
  local markers = M[check]
  if M[check] == nil then
    markers = M[nil]
  end

  ---@type table|string
  local root = vim.fs.find(markers, {
    upward = true,
    stop = vim.loop.os_homedir(),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })

  ---@diagnostic disable-next-line:param-type-mismatch
  if next(root) == nil then
    return vim.loop.cwd()
  else
    return vim.fs.dirname(root[1])
  end
end

return M
