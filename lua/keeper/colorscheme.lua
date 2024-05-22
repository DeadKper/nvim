local M = {}

---Set colorscheme if loaded, will use globals if available
---@param theme string
---@param transparency boolean
---@return boolean was_set whether the colorscheme was set
function M.set(theme, transparency)
	if not pcall(vim.cmd.colorscheme, theme or vim.g.colorscheme.theme) then
		return false
	end

	if transparency then
		local function set_transparent_hl(hlgroups, fg)
			for _, value in ipairs(hlgroups) do
				local id = vim.fn.synIDtrans(vim.fn.hlID(value))
				vim.api.nvim_set_hl(0, value, {
					fg = fg or vim.fn.synIDattr(id, "fg#"),
					bg = "NONE",
					sp = vim.fn.synIDattr(id, "sp#"),
					bold = vim.fn.synIDattr(id, "bold") == "1",
					italic = vim.fn.synIDattr(id, "italic") == "1",
					reverse = vim.fn.synIDattr(id, "reverse") == "1" or vim.fn.synIDattr(id, "inverse") == "1",
					standout = vim.fn.synIDattr(id, "standout") == "1",
					underline = vim.fn.synIDattr(id, "underline") == "1",
					undercurl = vim.fn.synIDattr(id, "undercurl") == "1",
					underdouble = vim.fn.synIDattr(id, "underdouble") == "1",
					underdotted = vim.fn.synIDattr(id, "underdotted") == "1",
					underdashed = vim.fn.synIDattr(id, "underdashed") == "1",
					strikethrough = vim.fn.synIDattr(id, "strikethrough") == "1",
					altfont = vim.fn.synIDattr(id, "altfont") == "1",
					nocombine = vim.fn.synIDattr(id, "nocombine") == "1",
				})
			end
		end

		set_transparent_hl({
			"Normal",
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
			"SignColumn",
			"CursorLineNr",
			"EndOfBuffer",
			"VertSplit",

			"DiagnosticVirtualTextError",
			"DiagnosticVirtualTextWarn",
			"DiagnosticVirtualTextInfo",
			"DiagnosticVirtualTextHint",
		})
		set_transparent_hl({
			"MasonMutedBlock",
		}, "#A0A0A0")

		-- Remove background from lazy
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("background-remove", { clear = true }),
			pattern = { "lazy" },
			once = true,
			callback = function()
				set_transparent_hl({
					"LazyButton",
				})
			end,
		})

		local times = 0
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			group = vim.api.nvim_create_augroup("background-remove-2", { clear = true }),
			callback = function()
				times = times + 1
				set_transparent_hl({
					"lualine_c_normal",
					"lualine_c_inactive",
				})
				if times == 2 then
					vim.api.nvim_clear_autocmds({ group = "background-remove-2" })
				end
			end,
		})
	end

	return true
end

return M
