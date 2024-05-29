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
		return hlgroup .. " " .. M.get_hl(is_link):match("[^ ]+ (.*)")
	end
	return hlgroup .. " " .. (hl:match("[^ ]+ +x+ *(.*)") or "")
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
---@return boolean was_set whether the colorscheme was set
function M.set(theme)
	if not pcall(vim.cmd.colorscheme, theme) then
		return false
	end

	local function set_transparent_bg(hlgroups)
		for _, value in ipairs(hlgroups) do
			local hl
			local hlstr

			if type(value) == "table" then
				hl = M.get_hl(value[1])
				hlstr = " guibg=NONE " .. value[2]
			else
				hl = M.get_hl(value)
				hlstr = " guibg=NONE"
			end

			if hl and hl:match("guibg") then
				pcall(vim.cmd.hi, hl:match("[^ ]+") .. hlstr)
			end
		end
	end

	if vim.g.transparencies.background then
		local clear = {
			"SignColumn",
			"EndOfBuffer",
			"DiffviewNormal",
			"DiffviewSignColumn",
			"DiffviewEndOfBuffer",
		}

		local normals = M.get_hls("^Normal")
		if normals then
			for _, value in ipairs(normals) do
				if value ~= "NormalFloat" then
					clear[#clear + 1] = value
				end
			end
		end

		vim.cmd.hi("NormalFloat " .. M.get_hl("Normal"):match("[^ ]+ (.*)"))
		set_transparent_bg(clear)
	end

	if vim.g.transparencies.lualine then
		vim.defer_fn(function()
			set_transparent_bg(M.get_hls("lualine_c_"))
			set_transparent_bg(M.get_hls("lualine_x_"))
			set_transparent_bg(M.get_hls("filetype_DevIcon"))
		end, 10)

		-- Autocmd for when a new one is created
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
					set_transparent_bg({
						"lualine_transitional_lualine_b_normal_to_lualine_c_normal",
					})
				end, 10)
			end,
		})
	end

	if vim.g.transparencies.floating then
		set_transparent_bg(M.get_hls("Border"))
		set_transparent_bg(M.get_hls("^Notify"))
		set_transparent_bg(M.get_hls("^DiagnosticVirtualText"))
		set_transparent_bg(M.get_hls("^DiagnosticSign"))

		set_transparent_bg({
			"NormalFloat",
			"Pmenu",
			"Conceal",
			"SignColumn",
			-- "Constant",
			-- "Comment",
			-- "Special",
			-- "Identifier",
			-- "Statement",
			-- "PreProc",
			-- "Type",
			-- "Underlined",
			-- "Todo",
			-- "String",
			-- "Function",
			-- "Conditional",
			-- "Repeat",
			-- "Operator",
			-- "Structure",
			-- "LineNr",
			-- "NonText",
			-- "CursorLineNr",
			-- "VertSplit",
			"LazyButton",
			{ "MasonMutedBlock", "guifg=#A0A0A0" },
		})

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
					{ "MasonMutedBlock", "guifg=#A0A0A0" },
				})
			end,
		})
	end

	return true
end

function M.apply(hlgroups)
	for hl, color in pairs(hlgroups) do
		local str = (color.fg and " guifg=" .. color.fg or "")
			.. (color.bg and " guibg=" .. color.bg or "")
			.. (color.gui and " gui=" .. color.gui or "")
		if str ~= "" then
			vim.cmd.hi(hl .. str)
		end
		if color[1] then
			vim.cmd("hi! link " .. hl .. " " .. color[1])
		end
	end
end

return M
