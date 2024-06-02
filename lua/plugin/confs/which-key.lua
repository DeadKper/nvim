local M = {}

---Key chains
---@type table<string, string|table<string>>
M.keys_list = {}

---Whether which-key has been setup or not, needs to be updated manually
M.loaded = false

---@param table table
---@return table copy
local function deep_copy(table)
	local res = {}
	for key, value in pairs(table) do
		res[key] = type(value) == "table" and deep_copy(value) or value
	end
	return res
end

---Registers currently saved key chaings
function M.register()
	local ok, wk = pcall(require, "which-key")
	if not ok then
		return
	end

	if not M.loaded then
		M.loaded = true
	end

	wk.register(M.get())
end

---Add key chains to the keys list, if which-key is loaded it will automatically register them
---@param table table<string, string|table<string>>
function M.add(table)
	for key, value in pairs(table) do
		if M.keys_list[key] then -- Key already exist
			if type(value) == "table" then
				if type(M.keys_list[key]) == "table" then
					local flag = true
					---@diagnostic disable-next-line:param-type-mismatch
					for _, v in ipairs(M.keys_list[key]) do
						if v.name == value.name then -- Add keys if they have different name
							flag = false
							break
						end
					end
					if flag then
						M.keys_list[key][#M.keys_list[key] + 1] = value
					end
				else -- Current value is a string, replace it
					M.keys_list[key] = { deep_copy(value) }
				end
			end
		else -- Key doesn't exist
			if type(value) == "table" then
				M.keys_list[key] = { deep_copy(value) }
			else
				M.keys_list[key] = value
			end
		end
	end

	if M.loaded then
		M.register()
	end
end

---Gets the merged table of registered keys_list
---@return table table<string, string|table<string>>
function M.get()
	local keys = {}

	for key, value in pairs(M.keys_list) do
		if type(value) == "table" then
			keys[key] = deep_copy(value[1])
			for i = 2, #value do
				keys[key].name = keys[key].name .. " + " .. value[i].name -- Merge key chains
				for k, v in pairs(value[i]) do
					if k ~= "name" then
						keys[key][k] = v
					end
				end
			end
		else
			keys[key] = value
		end
	end

	return keys
end

return M
