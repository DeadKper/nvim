local M = {}

---Get highlight group string
---@param hlgroup string
---@return string|nil
function M.get_hl(hlgroup)
	if hlgroup == "" then
		return nil
	end
	local has_hl, hl = pcall(vim.api.nvim_exec2, "hi " .. hlgroup, { output = true })
	if not has_hl then
		return nil
	end
	hl = hl.output
	local is_link = hl:match("links to ([^ ]+)")
	if is_link and is_link ~= "" then
		---@diagnostic disable-next-line:cast-local-type
		hl = M.get_hl(is_link)
	end
	return hl:match("([^ ]+)") .. " " .. (hl:match("[^ ]+ +x+ *(.*)") or "")
end

---@class HlReplace
---@field prefix string
---@field color string

---Replace existing highlight color to another
---@param hlgroup string
---@param replaces HlReplace|table<HlReplace>
function M.replace_hl(hlgroup, replaces)
	local hl = M.get_hl(hlgroup)

	if not hl then
		return
	end

	if replaces.prefix then
		replaces = { replaces }
	end

	for _, value in ipairs(replaces) do
		local current = hl:match(value.prefix .. "=[^ ]+")
		if current and current ~= "" then
			hl = hl:gsub(current, value.prefix .. "=" .. value.color)
		else
			hl = hl .. " " .. value.prefix .. "=" .. value.color
		end
	end

	vim.cmd.hi(hl)
end

---Get all group names from a case sensitive string match
---@param match any
---@return nil|table<string>
function M.get_hls(match)
	local has_hl, hl = pcall(vim.api.nvim_exec2, [[filter /\c]] .. match .. [[/ hi]], { output = true })
	if not has_hl then
		return nil
	end

	hl = vim.split(hl.output, "\n")

	for i, value in ipairs(hl) do
		hl[i] = value:match("[^ ]+")
	end

	return hl
end

---Set colorscheme if loaded, will use globals if available
---@param theme string
---@param transparency integer 3 = full transparency, 2 = background + lualine, 1 = only background, 0 = no transparency
---@return boolean was_set whether the colorscheme was set
function M.set(theme, transparency)
	if not pcall(vim.cmd.colorscheme, theme or vim.g.colorscheme.theme) then
		return false
	end

	if transparency > 0 then
		local function set_transparent_bg(hlgroups)
			for _, value in ipairs(hlgroups) do
				if type(value) == "table" then
					M.replace_hl(
						value[1],
						{ { prefix = value.prefix, color = value.color }, { prefix = "guibg", color = "NONE" } }
					)
				else
					M.replace_hl(value, { prefix = "guibg", color = "NONE" })
				end
			end
		end

		set_transparent_bg({
			"Normal",
			"EndOfBuffer",
			"SignColumn",
		})

		if transparency <= 1 then
			return true
		end

		-- Remove background from lualine
		local lualine_count_down = 5
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			group = vim.api.nvim_create_augroup("lualine-background-buf", { clear = true }),
			callback = function()
				vim.defer_fn(function()
					set_transparent_bg(M.get_hls("lualine_c_"))
					set_transparent_bg(M.get_hls("lualine_x_"))
				end, 10)

				lualine_count_down = lualine_count_down - 1
				if lualine_count_down <= 0 then
					vim.cmd("au! lualine-background-buf")
				end
			end,
		})

		local lualine_icon_hl_ft_set = {}
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("lualine-background", { clear = true }),
			callback = function()
				if vim.tbl_contains(lualine_icon_hl_ft_set, vim.bo.filetype) then
					return
				end

				lualine_icon_hl_ft_set[#lualine_icon_hl_ft_set + 1] = vim.bo.filetype
				vim.defer_fn(function()
					set_transparent_bg(M.get_hls("filetype_DevIcon"))
				end, 10)
			end,
		})

		if transparency <= 2 then
			return true
		end

		set_transparent_bg({
			"NormalFloat",
			"FloatBorder",
			"Pmenu",
			"Conceal",
			"SignColumn",
			"Comment",
			"Constant",
			"Special",
			"Identifier",
			"Statement",
			"PreProc",
			"Type",
			"Underlined",
			"Todo",
			"String",
			"Function",
			"Conditional",
			"Repeat",
			"Operator",
			"Structure",
			"LineNr",
			"NonText",
			"CursorLineNr",
			"VertSplit",
		})

		set_transparent_bg(M.get_hls("DiagnosticVirtualText"))

		-- Remove background from lazy
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = { "lazy" },
			once = true,
			callback = function()
				set_transparent_bg({
					"LazyButton",
				})
			end,
		})

		-- Remove background from mason
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = { "mason" },
			once = true,
			callback = function()
				set_transparent_bg({
					{ "MasonMutedBlock", prefix = "guifg", color = "A0A0A0" },
				})
			end,
		})
	end

	return true
end

return M
