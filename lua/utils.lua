local M = {}

---@type table<string>
M.conf_files = { '.nvim/nvim-dap.lua', '.nvim-dap/nvim-dap.lua', '.nvim-dap.lua' }

---@type table<string, table<string>>
M.root_markers = {
  ['rust'] = {
    'Cargo.toml',
    'rust-toolchain',
    'rust-project.json',
  },
  ['java'] = {
    'settings.gradle',
    'settings.gradle.kts',
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'mvnw',
    'gradlew',
  },
  ['default'] = {
    '.git',
  },
}

---@param check table<string>|string|nil table of root markers, string indicating the language or nil to check for default markers
---@return string|nil root the root of the project or nil if not found
function M.find_root(check)
  local markers
  if type(check) == 'table' then
    markers = check
  elseif check == nil or M.root_markers[check] == nil then
    markers = M.root_markers['default']
  else
    markers = vim.deepcopy(M.root_markers[check])
    for _, value in ipairs(M.root_markers['default']) do
      table.insert(markers, value)
    end
  end

  local root = vim.fs.find(markers, {
    upward = true,
    stop = vim.loop.os_homedir(),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })

  if next(root) == nil then
    return vim.loop.cwd()
  else
    return vim.fs.dirname(root[1])
  end
end

---@param regex string pattern to match
---@param path string|nil path to search in, nil for cwd
---@param limit number|nil limit of items to return
---@return table matches table with all normalized and matched files
function M.find(regex, path, limit)
  if path == nil then
    path = vim.loop.cwd()
  end

  if limit == nil then
    limit = 1
  end

  return vim.fs.find(function(name)
    return name:match(regex)
  end, { path = path, limit = limit })
end

---@param root string|nil root of the project to search in
---@param config table<string>|nil custom files to search
---@return string|nil config_file normalized config file path
function M.find_config(root, config)
  if root == nil then
    root = vim.loop.cwd()
  end

  if config == nil then
    config = M.conf_files
  end

  local found = nil
  for _, value in ipairs(config) do
    local search_path = root

    local dir = vim.fs.dirname(value)
    if dir ~= '.' then
      search_path = search_path .. '/' .. dir
    end

    found = vim.fs.find(vim.fs.basename(value), { path = search_path })
    if next(found) ~= nil then
      return found[1]
    end
  end

  return nil
end

---@param language string language to setup
---@param project_root string|nil path to project root dir
---@return string|nil config_file file that was setup or nil if it couldn't setup anything
function M.setup_config(language, project_root)
  local _, conf_file = next(M.conf_files)
  if not vim.fs.find(language, { path = vim.fn.stdpath 'config' .. '/lua/lsps' }) then
    return
  end

  if project_root == nil then
    local markers = M.root_markers[language]

    if M.root_markers[language] == nil then
      markers = M.root_markers['default']
    end

    project_root = M.find_root(markers)

    if project_root == nil then
      return
    end

    if project_root == '.' then
      project_root = vim.loop.cwd()
    end
  end

  local template = vim.fn.stdpath 'config' .. '/lua/debug/' .. language .. '.lua'
  local found = vim.fs.find(vim.fs.basename(template), { path = vim.fs.dirname(template) })
  if found == nil or next(found) == nil then
    return
  end

  local dir = vim.fs.dirname(conf_file)
  if dir ~= '.' then
    vim.loop.fs_mkdir(project_root .. '/' .. dir, 511)
  end

  vim.loop.fs_copyfile(template, project_root .. '/' .. conf_file, { excl = true })

  return conf_file
end

---@param path string path to search in
---@return table<string>|nil found list of lua files
function M.lua_files(path)
  local folder = vim.loop.fs_scandir(path)
  if folder == nil then
    return nil
  end
  local found = {}
  local file = vim.loop.fs_scandir_next(folder)
  while file ~= nil do
    file = file:match '(.+)[.]lua$'
    if file ~= nil then
      table.insert(found, file)
    end
    file = vim.loop.fs_scandir_next(folder)
  end
  return found
end

return M
