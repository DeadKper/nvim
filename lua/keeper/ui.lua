local M = {}
local icons = require("config.icons")

-- Original code from: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua

---@alias Sign {name:string, text:string, texthl:string, priority:number}
-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
	-- Get regular signs
	---@type Sign[]
	local signs = {}

	if vim.fn.has("nvim-0.10") == 0 then
		-- Only needed for Neovim <0.10
		-- Newer versions include legacy signs in nvim_buf_get_extmarks
		for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs) do
			local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as Sign]]
			if ret then
				ret.priority = sign.priority
				signs[#signs + 1] = ret
			end
		end
	end

	-- Get extmark signs
	local extmarks = vim.api.nvim_buf_get_extmarks(
		buf,
		-1,
		{ lnum - 1, 0 },
		{ lnum - 1, -1 },
		{ details = true, type = "sign" }
	)

	for _, extmark in pairs(extmarks) do
		signs[#signs + 1] = {
			name = extmark[4].sign_hl_group or "",
			text = extmark[4].sign_text,
			texthl = extmark[4].sign_hl_group,
			priority = extmark[4].priority,
		}
	end

	-- Sort by priority
	table.sort(signs, function(a, b)
		return (a.priority or 0) < (b.priority or 0)
	end)

	return signs
end

---@return Sign?
---@param buf number
---@param lnum number
function M.get_mark(buf, lnum)
	local marks = vim.fn.getmarklist(buf)
	vim.list_extend(marks, vim.fn.getmarklist())

	for _, mark in ipairs(marks) do
		if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
			return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
		end
	end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len)
	sign = sign or {}
	len = len or 2

	local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
	text = text .. string.rep(" ", len - vim.fn.strchars(text))
	return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

function M.statuscolumn()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local is_file = vim.bo[buf].buftype == ""
	local show_signs = vim.wo[win].signcolumn ~= "no"
	local status = {
		nums = nil,
		gitsg = nil,
		folds = nil,
		fopen = nil,
		fclse = nil,
		signs = nil,
		marks = nil,
	}

	if show_signs then
		---@type Sign?,Sign?,Sign?
		local signs, gitsg, fold
		for _, s in ipairs(M.get_signs(buf, vim.v.lnum)) do
			if s.name and (s.name:find("GitSign") or s.name:find("MiniDiffSign")) then
				gitsg = s
			else
				signs = s
			end
		end

		if vim.v.virtnum ~= 0 then
			signs = nil
		end

		vim.api.nvim_win_call(win, function()
			if vim.fn.foldlevel(vim.v.lnum - 1) < vim.fn.foldlevel(vim.v.lnum) then
				fold = { text = vim.opt.fillchars:get().foldopen or icons.fold.open, texthl = "Unfolded" }
				status.folds = M.icon(fold)
				status.fopen = M.icon(fold)
			end
			if vim.fn.foldclosed(vim.v.lnum) >= 0 then
				fold = { text = vim.opt.fillchars:get().foldclose or icons.fold.close, texthl = "Folded" }
				status.folds = M.icon(fold)
				status.fclse = M.icon(fold)
			end
		end)

		if is_file then
			local mark = M.get_mark(buf, vim.v.lnum)
			if mark and vim.g.temp_mark and not mark.text:match(vim.g.temp_mark) then
				status.marks = M.icon(mark)
			end

			if signs then
				status.signs = M.icon(signs)
			end

			if gitsg then
				status.gitsg = M.icon(gitsg)
			end
		end
	end
	-- Numbers in Neovim are weird
	-- They show when either number or relativenumber is true
	local is_num = vim.wo[win].number
	local is_relnum = vim.wo[win].relativenumber
	if is_num or is_relnum then
		local num
		if is_num and is_relnum then
			num = vim.v.lnum < vim.v.relnum and vim.v.relnum or vim.v.lnum
		elseif is_num then
			num = vim.v.lnum
		else
			num = vim.v.relnum
		end

		local pad = num and (num < 10 and "  " or num < 100 and " ") or ""
		if vim.v.virtnum == 0 then
			if vim.v.relnum == 0 then
				status.nums = is_num and "%l" or "%r" -- current line
			else
				status.nums = is_relnum and "%r" or "%l" -- other lines
			end
			if vim.g.statuscolumn.rnupad == 1 and is_relnum and vim.v.relnum == 0 then
				status.nums = status.nums .. pad .. "%= " -- left align
			else
				status.nums = pad .. "%=" .. status.nums .. " " -- right align
			end
		else
			status.nums = pad .. "%= " -- don't know what this does but lazyvim did it
		end
	end

	local col = {}
	for i, component in ipairs(vim.g.statuscolumn.display) do
		if type(component) ~= "table" then
			---@diagnostic disable-next-line:cast-local-type
			component = { component }
		end
		for _, value in ipairs(component) do
			if status[value] ~= nil then
				col[i] = col[i] or status[value]
			end
		end

		if col[i] == nil then
			col[i] = show_signs and "  " or ""
		end
	end

	if vim.g.statuscolumn.nums_cond then
		return (is_num or is_relnum) and table.concat(col, "") or ""
	end

	return table.concat(col, "")
end

---@param str string
---@param targetWidth number
---@return string
local function truncateStrByWidth(str, targetWidth)
	str = str:gsub("%z", "^@")
	if vim.fn.strdisplaywidth(str) <= targetWidth then
		return str
	end
	local width = 0
	local byteOff = 0
	while true do
		local part = vim.fn.strpart(str, byteOff, 1, 1)
		width = width + vim.fn.strdisplaywidth(part)
		if width > targetWidth then
			break
		end
		byteOff = byteOff + #part
	end
	return str:sub(1, byteOff)
end

function M.foldtext()
	local ok = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
	local ret = ok and vim.treesitter.foldtext and vim.treesitter.foldtext()
	if not ret or type(ret) == "string" then
		---@diagnostic disable-next-line:cast-local-type
		ret = {
			{
				truncateStrByWidth(
					vim.api
						.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1]
						:gsub("\t", string.rep(" ", vim.fn.eval("&ts"))),
					vim.fn.winwidth(0) - 8
				),
				{},
			},
		}
	end
	table.insert(ret, { string.format(" %s %d ", icons.fold.folded, vim.v.foldend - vim.v.foldstart) })
	if not vim.treesitter.foldtext then
		return table.concat(
			vim.tbl_map(function(line)
				return line[1]
			end, ret),
			" "
		)
	end
	return ret
end

return M
