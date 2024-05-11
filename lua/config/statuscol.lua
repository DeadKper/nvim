local M = {}

local icons = require('config.icons')

---@alias Sign {name:string, text:string, texthl:string, priority:number}

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
  -- Get regular signs
  ---@type Sign[]
  local signs = {}

  if vim.fn.has('nvim-0.10') == 1 then
    -- Only needed for Neovim <0.10
    -- Newer versions include legacy signs in nvim_buf_get_extmarks
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = '*', lnum = lnum })[1].signs) do
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
    { details = true, type = 'sign' }
  )
  for _, extmark in pairs(extmarks) do
    signs[#signs + 1] = {
      name = extmark[4].sign_hl_group or '',
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
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match('[a-zA-Z]') then
      return { text = mark.mark:sub(2), texthl = 'DiagnosticHint' }
    end
  end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or '', 0, len) ---@type string
  text = text .. string.rep(' ', len - vim.fn.strchars(text))
  return sign.texthl and ('%#' .. sign.texthl .. '#' .. text .. '%*') or text
end

function M.foldtext()
  local ok = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
  local ret = ok and vim.treesitter.foldtext and vim.treesitter.foldtext()
  if not ret or type(ret) == 'string' then
    ---@diagnostic disable-next-line:cast-local-type
    ret = { { vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1], {} } }
  end
  table.insert(ret, { ' ' .. icons.dots })

  if not vim.treesitter.foldtext then
    return table.concat(
      vim.tbl_map(function(line)
        return line[1]
      end, ret),
      ' '
    )
  end
  return ret
end

function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ''
  local show_signs = vim.wo[win].signcolumn ~= 'no'

  local colicons = {
    nnums = '',
    pnums = '',
    gitsg = '',
    folds = '',
    signs = '',
  }

  if show_signs then
    ---@type Sign?,Sign?,Sign?
    local signs, gitsg, fold
    for _, s in ipairs(M.get_signs(buf, vim.v.lnum)) do
      if s.name and (s.name:find('GitSign') or s.name:find('MiniDiffSign')) then
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
        fold = { text = vim.opt.fillchars:get().foldopen or icons.fold.open, texthl = 'Unfolded' }
      end
      if vim.fn.foldclosed(vim.v.lnum) >= 0 then
        fold = { text = vim.opt.fillchars:get().foldclose or icons.fold.close, texthl = 'Folded' }
      end
    end)

    colicons.folds = M.icon(fold)
    colicons.gitsg = is_file and M.icon(gitsg)
    colicons.signs = M.get_mark(buf, vim.v.lnum) or signs and M.icon(M.get_mark(buf, vim.v.lnum) or signs)
  end

  -- Numbers in Neovim are weird
  -- They show when either number or relativenumber is true
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.v.relnum == 0 then
      -- pad to the left if rnu is enabled
      colicons.pnums = is_relnum and is_num and '%l ' or not is_relnum and is_num and ' %l' or '%r ' -- current line
      colicons.nnums = is_num and '%l' or '%r '
    else
      colicons.pnums = is_relnum and '%r' or '%l' -- other lines
      colicons.nnums = is_relnum and '%r' or '%l'
    end
    colicons.pnums = '%=' .. colicons.pnums .. ' ' -- right align
    colicons.nnums = '%=' .. colicons.nnums .. ' '
  end

  if vim.v.virtnum ~= 0 then
    colicons.pnums = '%= '
    colicons.nnums = '%= '
  end

  return table.concat({
    colicons.folds or '',
    colicons.pnums or '',
    colicons.signs or colicons.gitsg or '',
  }, '')
end

M.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.uv.new_check())

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then
    return '0'
  end

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= '' then
    return '0'
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == '' then
    return '0'
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return '0'
end

return M
