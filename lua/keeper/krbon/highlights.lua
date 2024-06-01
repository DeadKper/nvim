---@class KrbonHighlight
---@field [1] string|nil link or base colors to extend
---@field fg string|nil color for guifg
---@field bg string|nil color for guibg
---@field sp string|nil color for guisp
---@field fmt string|nil string indicating the formats to use, ex: "underline,italic"

---@alias KrbonHighlightGroups table<string, KrbonHighlight>

local M = {}

---Returns highlight group spec
---@param hl string
---@param groups KrbonHighlightGroups
---@return KrbonHighlight spec
local function getAttrs(hl, groups)
	if groups[hl] == nil then
		return {}
	elseif groups[hl][1] ~= nil then
		return vim.tbl_deep_extend("force", {}, getAttrs(groups[hl][1], groups), groups[hl])
	else
		return groups[hl]
	end
end

local function apply(highlights)
	if next(highlights) == nil then
		return
	end

	for hl, _ in pairs(highlights) do
		local color = getAttrs(hl, highlights)

		if color[1] ~= nil and next(color, 1) == nil then
			vim.cmd.hi("link " .. hl .. " " .. color[1])
		else
			local str = ""
			if color.fg ~= nil then
				str = str .. " guifg=" .. color.fg
			end
			if color.bg ~= nil then
				str = str .. " guibg=" .. color.bg
			end
			if color.sp ~= nil then
				str = str .. " guisp=" .. color.sp
			end
			if color.fmt ~= nil then
				str = str .. " gui=" .. color.fmt
			end

			if str ~= "" then
				vim.cmd.hi(hl .. str)
			end
		end
	end
end

function M.setup0()
	local c = require("keeper.krbon.onedark")
	local p = require("keeper.krbon.palette")
	local cfg = require("keeper.krbon.config")
	local util = require("keeper.krbon.util")

	local diagnostics_error_color = cfg.diagnostics.darker and c.dark_red or c.red
	local diagnostics_hint_color = cfg.diagnostics.darker and c.dark_purple or c.purple
	local diagnostics_warn_color = cfg.diagnostics.darker and c.dark_yellow or c.yellow
	local diagnostics_info_color = cfg.diagnostics.darker and c.dark_cyan or c.cyan

	---@type KrbonHighlightGroups
	local highlights = {
		-- Transparency
		Normal = { fg = p.fg0, bg = cfg.transparent and p.none or p.bg0 },
		NormalFloat = { fg = p.fg0, bg = cfg.float_transparent and p.none or p.bg1 },
		NormalLight = { fg = p.fg0, bg = cfg.transparent and p.none or p.bg1 },
		EndingTildes = {
			fg = cfg.transparent and p.none or (cfg.ending_tildes and p.bg3 or p.bg0),
			bg = cfg.transparent and p.none or p.bg1,
		},

		-- Vim
		EndOfBuffer = { "EndingTildes" },
		Folded = { "NormalLight" },
		Terminal = { "Normal" },
		FoldColumn = { "NormalLight" },
		SignColumn = { "Normal" },
		ToolbarLine = { fg = p.fg0 },
		Cursor = { fmt = "reverse" },
		vCursor = { fmt = "reverse" },
		iCursor = { fmt = "reverse" },
		lCursor = { fmt = "reverse" },
		CursorIM = { fmt = "reverse" },
		CursorColumn = { bg = p.bg2 },
		CursorLine = { bg = p.bg2 },
		ColorColumn = { bg = p.bg3 },
		CursorLineNr = { fg = p.fg0 },
		LineNr = { fg = p.fg2 },
		Conceal = { fg = p.fg1, bg = p.bg1 },
		Added = { fg = c.green },
		Removed = { fg = c.red },
		Changed = { fg = c.blue },
		DiffAdd = { fg = c.none, bg = c.diff_add },
		DiffChange = { fg = c.none, bg = c.diff_change },
		DiffDelete = { fg = c.none, bg = c.diff_delete },
		DiffText = { fg = c.none, bg = c.diff_text },
		DiffAdded = { fg = c.green },
		DiffChanged = { fg = c.blue },
		DiffRemoved = { fg = c.red },
		DiffDeleted = { fg = c.red },
		DiffFile = { fg = c.cyan },
		DiffIndexLine = { fg = p.fg2 },
		Directory = { fg = c.blue },
		ErrorMsg = { fg = c.red, fmt = "bold" },
		WarningMsg = { fg = c.yellow, fmt = "bold" },
		MoreMsg = { fg = c.blue, fmt = "bold" },
		CurSearch = { fg = p.bg0, bg = c.orange },
		IncSearch = { fg = p.bg0, bg = c.orange },
		Search = { fg = p.bg0, bg = c.bg_yellow },
		Substitute = { fg = p.bg0, bg = p.lavender },
		MatchParen = { fg = c.none, bg = p.fg2 },
		NonText = { fg = p.fg2 },
		Whitespace = { fg = p.fg2 },
		SpecialKey = { fg = p.fg2 },
		Pmenu = { fg = p.fg0, bg = p.bg1 },
		PmenuSbar = { fg = c.none, bg = p.bg1 },
		PmenuSel = { fg = p.bg0, bg = c.bg_blue },
		WildMenu = { fg = p.bg0, bg = c.blue },
		PmenuThumb = { fg = c.none, bg = p.fg2 },
		Question = { fg = c.yellow },
		SpellBad = { fg = c.none, fmt = "undercurl", sp = c.red },
		SpellCap = { fg = c.none, fmt = "undercurl", sp = c.yellow },
		SpellLocal = { fg = c.none, fmt = "undercurl", sp = c.blue },
		SpellRare = { fg = c.none, fmt = "undercurl", sp = c.purple },
		StatusLine = { fg = p.fg0, bg = p.bg2 },
		StatusLineTerm = { fg = p.fg0, bg = p.bg2 },
		StatusLineNC = { fg = p.fg2, bg = p.bg1 },
		StatusLineTermNC = { fg = p.fg2, bg = p.bg1 },
		TabLine = { fg = p.fg0, bg = p.bg1 },
		TabLineFill = { fg = p.fg2, bg = p.bg1 },
		TabLineSel = { fg = p.bg0, bg = p.fg0 },
		WinSeparator = { fg = p.bg3 },
		Visual = { bg = p.bg3 },
		VisualNOS = { fg = c.none, bg = p.bg2, fmt = "underline" },
		QuickFixLine = { fg = c.blue, fmt = "underline" },
		Debug = { fg = c.yellow },
		debugPC = { fg = p.bg0, bg = c.green },
		debugBreakpoint = { fg = p.bg0, bg = c.red },
		ToolbarButton = { fg = p.bg0, bg = c.bg_blue },
		FloatBorder = { "NormalFloat", fg = p.fg1 },
		FloatTitle = { "NormalFloat", fg = c.cyan },

		-- Syntax
		String = { fg = p.lavender }, -- strings
		Character = { fg = c.orange },
		Number = { fg = p.sky },
		Float = { fg = p.sky },
		Boolean = { fg = p.sky },
		Type = { fg = c.yellow },
		Structure = { fg = c.yellow },
		StorageClass = { fg = c.yellow },
		Identifier = { fg = c.red }, -- variables
		Constant = { fg = c.cyan },
		PreProc = { fg = p.blue },
		PreCondit = { fg = p.blue },
		Include = { fg = p.blue },
		Keyword = { fg = p.blue }, -- keywords
		Define = { fg = p.blue },
		Typedef = { fg = c.yellow },
		Exception = { fg = p.blue },
		Conditional = { fg = p.blue }, -- keywords
		Repeat = { fg = p.blue }, -- keywords
		Statement = { fg = p.blue },
		Macro = { fg = c.red },
		Error = { fg = p.blue },
		Label = { fg = p.blue },
		Special = { fg = c.red },
		SpecialChar = { fg = c.red },
		Function = { fg = p.pink }, -- functions
		Operator = { fg = c.purple },
		Title = { fg = c.cyan },
		Tag = { fg = p.lavender },
		Delimiter = { fg = p.fg1 },
		Comment = { fg = p.fg2, fmt = "italic" }, -- comments
		SpecialComment = { fg = p.fg2, fmt = "italic" }, -- comments
		Todo = { fg = c.red, fmt = "italic" }, -- comments

		-- Treesitter
		["@annotation"] = { fg = p.fg0 },
		["@attribute"] = { fg = p.magenta },
		["@attribute.typescript"] = { fg = c.blue },
		["@boolean"] = { "Booeal" },
		["@character"] = { "Character" },
		["@comment"] = { fg = p.fg2 }, -- comments
		["@comment.todo"] = { fg = c.red }, -- comments
		["@comment.todo.unchecked"] = { fg = c.red }, -- comments
		["@comment.todo.checked"] = { fg = c.green }, -- comments
		["@constant"] = { "Constant" }, -- constants
		["@constant.builtin"] = { "Constant" }, -- constants
		["@constant.macro"] = { "Constant" }, -- constants
		["@constructor"] = { fg = c.yellow, fmt = "bold" },
		["@diff.add"] = { "DiffAdded" },
		["@diff.delete"] = { "DiffDeleted" },
		["@diff.plus"] = { "DiffAdded" },
		["@diff.minus"] = { "DiffDeleted" },
		["@diff.delta"] = { "DiffChanged" },
		["@error"] = { fg = p.fg0 },
		["@function"] = { fg = p.pink }, -- functions
		["@function.builtin"] = { fg = p.pink }, -- functions
		["@function.macro"] = { fg = p.pink }, -- functions
		["@function.method"] = { fg = p.pink }, -- functions
		["@keyword"] = { fg = p.blue }, -- keywords
		["@keyword.conditional"] = { fg = p.blue }, -- keywords
		["@keyword.directive"] = { fg = p.blue },
		["@keyword.exception"] = { fg = p.blue },
		["@keyword.function"] = { fg = p.blue }, -- functions
		["@keyword.import"] = { fg = p.blue },
		["@keyword.operator"] = { fg = p.blue }, -- keywords
		["@keyword.repeat"] = { fg = p.blue }, -- keywords
		["@label"] = { fg = c.red },
		["@markup.emphasis"] = { fg = p.fg0, fmt = "italic" },
		["@markup.environment"] = { fg = p.fg0 },
		["@markup.environment.name"] = { fg = p.fg0 },
		["@markup.heading"] = { fg = p.sky, fmt = "bold" },
		["@markup.link"] = { fg = c.blue },
		["@markup.link.url"] = { fg = c.cyan, fmt = "underline" },
		["@markup.list"] = { fg = c.red },
		["@markup.math"] = { fg = p.fg0 },
		["@markup.raw"] = { fg = p.lavender },
		["@markup.strike"] = { fg = p.fg0, fmt = "strikethrough" },
		["@markup.strong"] = { fg = p.fg0, fmt = "bold" },
		["@markup.underline"] = { fg = p.fg0, fmt = "underline" },
		["@module"] = { fg = c.yellow },
		["@none"] = { fg = p.fg0 },
		["@number"] = { "Number" },
		["@number.float"] = { "Float" },
		["@operator"] = { fg = p.fg0 },
		["@parameter.reference"] = { fg = p.fg0 },
		["@property"] = { fg = p.magenta },
		["@punctuation.delimiter"] = { fg = p.fg1 },
		["@punctuation.bracket"] = { fg = p.fg1 },
		["@string"] = { "String" }, -- strings
		["@string.regexp"] = { fg = c.orange }, -- strings
		["@string.escape"] = { fg = c.red }, -- strings
		["@string.special.symbol"] = { fg = p.magenta },
		["@tag"] = { fg = p.blue },
		["@tag.attribute"] = { fg = c.yellow },
		["@tag.delimiter"] = { fg = p.blue },
		["@text"] = { fg = p.fg0 },
		["@note"] = { fg = p.fg0 },
		["@warning"] = { fg = p.fg0 },
		["@danger"] = { fg = p.fg0 },
		["@type"] = { fg = c.yellow },
		["@type.builtin"] = { fg = p.sky },
		["@variable"] = { fg = p.fg0 }, -- variables
		["@variable.builtin"] = { fg = p.magenta }, -- variables
		["@variable.member"] = { fg = p.magenta },
		["@variable.parameter"] = { fg = p.gray },
		["@markup.heading.1.markdown"] = { fg = c.red, fmt = "bold" },
		["@markup.heading.2.markdown"] = { fg = c.purple, fmt = "bold" },
		["@markup.heading.3.markdown"] = { fg = c.orange, fmt = "bold" },
		["@markup.heading.4.markdown"] = { fg = c.red, fmt = "bold" },
		["@markup.heading.5.markdown"] = { fg = c.purple, fmt = "bold" },
		["@markup.heading.6.markdown"] = { fg = c.orange, fmt = "bold" },
		["@markup.heading.1.marker.markdown"] = { fg = c.red, fmt = "bold" },
		["@markup.heading.2.marker.markdown"] = { fg = c.purple, fmt = "bold" },
		["@markup.heading.3.marker.markdown"] = { fg = c.orange, fmt = "bold" },
		["@markup.heading.4.marker.markdown"] = { fg = c.red, fmt = "bold" },
		["@markup.heading.5.marker.markdown"] = { fg = c.purple, fmt = "bold" },
		["@markup.heading.6.marker.markdown"] = { fg = c.orange, fmt = "bold" },

		-- Lsp
		["@lsp.type.comment"] = { "@comment" },
		["@lsp.type.enum"] = { "@type" },
		["@lsp.type.enumMember"] = { "@constant.builtin" },
		["@lsp.type.interface"] = { "@type" },
		["@lsp.type.typeParameter"] = { "@type" },
		["@lsp.type.keyword"] = { "@keyword" },
		["@lsp.type.namespace"] = { "@module" },
		["@lsp.type.parameter"] = { "@variable.parameter" },
		["@lsp.type.property"] = { "@property" },
		["@lsp.type.variable"] = { "@variable" },
		["@lsp.type.macro"] = { "@function.macro" },
		["@lsp.type.method"] = { "@function.method" },
		["@lsp.type.number"] = { "@number" },
		["@lsp.type.generic"] = { "@text" },
		["@lsp.type.builtinType"] = { "@type.builtin" },
		["@lsp.typemod.method.defaultLibrary"] = { "@function" },
		["@lsp.typemod.function.defaultLibrary"] = { "@function" },
		["@lsp.typemod.operator.injected"] = { "@operator" },
		["@lsp.typemod.string.injected"] = { "@string" },
		["@lsp.typemod.variable.defaultLibrary"] = { "@variable.builtin" },
		["@lsp.typemod.variable.injected"] = { "@variable" },
		["@lsp.typemod.variable.static"] = { "@constant" },

		LspCxxHlGroupEnumConstant = { fg = c.orange },
		LspCxxHlGroupMemberVariable = { fg = c.orange },
		LspCxxHlGroupNamespace = { fg = c.blue },
		LspCxxHlSkippedRegion = { fg = p.fg2 },
		LspCxxHlSkippedRegionBeginEnd = { fg = c.red },

		DiagnosticError = { fg = c.red },
		DiagnosticHint = { fg = c.purple },
		DiagnosticInfo = { fg = c.cyan },
		DiagnosticWarn = { fg = c.yellow },

		DiagnosticVirtualTextError = { fg = diagnostics_error_color },
		DiagnosticVirtualTextWarn = { fg = diagnostics_warn_color },
		DiagnosticVirtualTextInfo = { fg = diagnostics_info_color },
		DiagnosticVirtualTextHint = { fg = diagnostics_hint_color },

		DiagnosticUnderlineError = { fmt = "undercurl", sp = c.red },
		DiagnosticUnderlineHint = { fmt = "undercurl", sp = c.purple },
		DiagnosticUnderlineInfo = { fmt = "undercurl", sp = c.blue },
		DiagnosticUnderlineWarn = { fmt = "undercurl", sp = c.yellow },

		LspReferenceText = { bg = p.bg2 },
		LspReferenceWrite = { bg = p.bg2 },
		LspReferenceRead = { bg = p.bg2 },

		LspCodeLens = { fg = p.fg2 }, -- comments
		LspCodeLensSeparator = { fg = p.fg2 },

		LspDiagnosticsDefaultError = { "DiagnosticError" },
		LspDiagnosticsDefaultHint = { "DiagnosticHint" },
		LspDiagnosticsDefaultInformation = { "DiagnosticInfo" },
		LspDiagnosticsDefaultWarning = { "DiagnosticWarn" },
		LspDiagnosticsUnderlineError = { "DiagnosticUnderlineError" },
		LspDiagnosticsUnderlineHint = { "DiagnosticUnderlineHint" },
		LspDiagnosticsUnderlineInformation = { "DiagnosticUnderlineInfo" },
		LspDiagnosticsUnderlineWarning = { "DiagnosticUnderlineWarn" },
		LspDiagnosticsVirtualTextError = { "DiagnosticVirtualTextError" },
		LspDiagnosticsVirtualTextWarning = { "DiagnosticVirtualTextWarn" },
		LspDiagnosticsVirtualTextInformation = { "DiagnosticVirtualTextInfo" },
		LspDiagnosticsVirtualTextHint = { "DiagnosticVirtualTextHint" },

		-- Plugins

		-- Ale
		ALEErrorSign = { "DiagnosticError" },
		ALEInfoSign = { "DiagnosticInfo" },
		ALEWarningSign = { "DiagnosticWarn" },

		-- Barbar
		BufferCurrent = { fmt = "bold" },
		BufferCurrentMod = { fg = c.orange, fmt = "bold,italic" },
		BufferCurrentSign = { fg = c.purple },
		BufferInactiveMod = { fg = p.fg1, bg = p.bg1, fmt = "italic" },
		BufferVisible = { fg = p.fg1, bg = p.bg0 },
		BufferVisibleMod = { fg = c.yellow, bg = p.bg0, fmt = "italic" },
		BufferVisibleIndex = { fg = p.fg1, bg = p.bg0 },
		BufferVisibleSign = { fg = p.fg1, bg = p.bg0 },
		BufferVisibleTarget = { fg = p.fg1, bg = p.bg0 },

		-- Cmp
		CmpItemAbbr = { fg = p.fg0 },
		CmpItemAbbrDeprecated = { fg = p.fg1, fmt = "strikethrough" },
		CmpItemAbbrMatch = { fg = c.cyan },
		CmpItemAbbrMatchFuzzy = { fg = c.cyan, fmt = "underline" },
		CmpItemMenu = { fg = p.fg1 },
		CmpItemKind = { fg = c.purple, fmt = cfg.cmp_itemkind_reverse and "reverse" or nil },

		-- Coc
		CocErrorSign = { "DiagnosticError" },
		CocHintSign = { "DiagnosticHint" },
		CocInfoSign = { "DiagnosticInfo" },
		CocWarningSign = { "DiagnosticWarn" },

		-- Which Key
		WhichKey = { fg = c.red },
		WhichKeyDesc = { fg = c.blue },
		WhichKeyGroup = { fg = c.orange },
		WhichKeySeparator = { fg = c.green },

		-- Git Gutter
		GitGutterAdd = { fg = c.green },
		GitGutterChange = { fg = c.blue },
		GitGutterDelete = { fg = c.red },

		-- Hop
		HopNextKey = { fg = c.red, fmt = "bold" },
		HopNextKey1 = { fg = c.cyan, fmt = "bold" },
		HopNextKey2 = { fg = util.darken(c.blue, 0.7) },
		HopUnmatched = { fg = p.fg2 },

		-- Diffview
		DiffviewFilePanelTitle = { fg = c.blue, fmt = "bold" },
		DiffviewFilePanelCounter = { fg = c.purple, fmt = "bold" },
		DiffviewFilePanelFileName = { fg = p.fg0 },
		DiffviewNormal = { "Normal" },
		DiffviewCursorLine = { "CursorLine" },
		DiffviewVertSplit = { "VertSplit" },
		DiffviewSignColumn = { "SignColumn" },
		DiffviewStatusLine = { "StatusLine" },
		DiffviewStatusLineNC = { "StatusLineNC" },
		DiffviewEndOfBuffer = { "EndOfBuffer" },
		DiffviewFilePanelRootPath = { fg = p.fg2 },
		DiffviewFilePanelPath = { fg = p.fg2 },
		DiffviewFilePanelInsertions = { fg = c.green },
		DiffviewFilePanelDeletions = { fg = c.red },
		DiffviewStatusAdded = { fg = c.green },
		DiffviewStatusUntracked = { fg = c.blue },
		DiffviewStatusModified = { fg = c.blue },
		DiffviewStatusRenamed = { fg = c.blue },
		DiffviewStatusCopied = { fg = c.blue },
		DiffviewStatusTypeChange = { fg = c.blue },
		DiffviewStatusUnmerged = { fg = c.blue },
		DiffviewStatusUnknown = { fg = c.red },
		DiffviewStatusDeleted = { fg = c.red },
		DiffviewStatusBroken = { fg = c.red },

		-- Gitsigns
		GitSignsAdd = { fg = c.green },
		GitSignsAddLn = { fg = c.green },
		GitSignsAddNr = { fg = c.green },
		GitSignsChange = { fg = c.blue },
		GitSignsChangeLn = { fg = c.blue },
		GitSignsChangeNr = { fg = c.blue },
		GitSignsDelete = { fg = c.red },
		GitSignsDeleteLn = { fg = c.red },
		GitSignsDeleteNr = { fg = c.red },

		-- Neotree
		NeoTreeNormal = { fg = p.fg0, bg = cfg.transparent and c.none or p.bg0 },
		NeoTreeNormalNC = { fg = p.fg0, bg = cfg.transparent and c.none or p.bg0 },
		NeoTreeVertSplit = { fg = p.bg1, bg = cfg.transparent and c.none or p.bg1 },
		NeoTreeWinSeparator = { fg = p.bg1, bg = cfg.transparent and c.none or p.bg1 },
		NeoTreeEndOfBuffer = { fg = cfg.ending_tildes and p.bg2 or p.bg0, bg = cfg.transparent and c.none or c.bg_d },
		NeoTreeRootName = { fg = c.orange, fmt = "bold" },
		NeoTreeGitAdded = { fg = c.green },
		NeoTreeGitDeleted = { fg = c.red },
		NeoTreeGitModified = { fg = c.yellow },
		NeoTreeGitConflict = { fg = c.red, fmt = "bold,italic" },
		NeoTreeGitUntracked = { fg = c.red, fmt = "italic" },
		NeoTreeIndentMarker = { fg = p.fg2 },
		NeoTreeSymbolicLinkTarget = { fg = c.purple },

		-- Neotest
		NeotestAdapterName = { fg = c.purple, fmt = "bold" },
		NeotestDir = { fg = c.cyan },
		NeotestExpandMarker = { fg = p.fg2 },
		NeotestFailed = { fg = c.red },
		NeotestFile = { fg = c.cyan },
		NeotestFocused = { fmt = "bold,italic" },
		NeotestIndent = { fg = p.fg2 },
		NeotestMarked = { fg = c.orange, fmt = "bold" },
		NeotestNamespace = { fg = c.blue },
		NeotestPassed = { fg = c.green },
		NeotestRunning = { fg = c.yellow },
		NeotestWinSelect = { fg = c.cyan, fmt = "bold" },
		NeotestSkipped = { fg = p.fg1 },
		NeotestTarget = { fg = c.purple },
		NeotestTest = { fg = p.fg0 },
		NeotestUnknown = { fg = p.fg1 },

		-- Nvim Tree
		NvimTreeNormal = { fg = p.fg0, bg = cfg.transparent and c.none or p.bg0 },
		NvimTreeVertSplit = { fg = p.bg0, bg = cfg.transparent and c.none or c.bg_d },
		NvimTreeEndOfBuffer = { fg = cfg.ending_tildes and p.bg2 or p.bg0, bg = cfg.transparent and c.none or c.bg_d },
		NvimTreeRootFolder = { fg = c.orange, fmt = "bold" },
		NvimTreeGitDirty = { fg = c.yellow },
		NvimTreeGitNew = { fg = c.green },
		NvimTreeGitDeleted = { fg = c.red },
		NvimTreeSpecialFile = { fg = c.yellow, fmt = "underline" },
		NvimTreeIndentMarker = { fg = p.fg0 },
		NvimTreeImageFile = { fg = c.dark_purple },
		NvimTreeSymlink = { fg = c.purple },
		NvimTreeFolderName = { fg = c.blue },

		-- Telescope
		TelescopeNormal = { "NormalFloat" },
		TelescopeTitle = { "FloatTitle" },
		TelescopeBorder = { "FloatBorder" },
		TelescopePromptBorder = { "TelescopeBorder" },
		TelescopeResultsBorder = { "TelescopeBorder" },
		TelescopePreviewBorder = { "TelescopeBorder" },
		TelescopeMatching = { fg = c.orange, fmt = "bold" },
		TelescopePromptPrefix = { fg = c.green },
		TelescopeSelectionCaret = { fg = c.yellow },

		-- Dashboard
		DashboardShortCut = { fg = c.blue },
		DashboardHeader = { fg = c.yellow },
		DashboardCenter = { fg = c.cyan },
		DashboardFooter = { fg = c.dark_red, fmt = "italic" },

		-- Outline
		FocusedSymbol = { fg = c.purple, bg = p.bg2, fmt = "bold" },
		AerialLine = { fg = c.purple, bg = p.bg2, fmt = "bold" },

		-- Navic
		NavicText = { fg = p.fg0 },
		NavicSeparator = { fg = p.fg1 },

		-- Ts Rainbow
		rainbowcol1 = { fg = p.fg1 },
		rainbowcol2 = { fg = c.yellow },
		rainbowcol3 = { fg = c.blue },
		rainbowcol4 = { fg = c.orange },
		rainbowcol5 = { fg = c.purple },
		rainbowcol6 = { fg = c.green },
		rainbowcol7 = { fg = c.red },

		-- Ts Rainbow 2
		TSRainbowRed = { fg = c.red },
		TSRainbowYellow = { fg = c.yellow },
		TSRainbowBlue = { fg = c.blue },
		TSRainbowOrange = { fg = c.orange },
		TSRainbowGreen = { fg = c.green },
		TSRainbowViolet = { fg = c.purple },
		TSRainbowCyan = { fg = c.cyan },

		-- Rainbow Delimiters
		RainbowDelimiterRed = { fg = c.red },
		RainbowDelimiterYellow = { fg = c.yellow },
		RainbowDelimiterBlue = { fg = c.blue },
		RainbowDelimiterOrange = { fg = c.orange },
		RainbowDelimiterGreen = { fg = c.green },
		RainbowDelimiterViolet = { fg = c.purple },
		RainbowDelimiterCyan = { fg = c.cyan },

		-- Indent Blankline
		IndentBlanklineIndent1 = { fg = c.blue },
		IndentBlanklineIndent2 = { fg = c.green },
		IndentBlanklineIndent3 = { fg = c.cyan },
		IndentBlanklineIndent4 = { fg = p.fg1 },
		IndentBlanklineIndent5 = { fg = c.purple },
		IndentBlanklineIndent6 = { fg = c.red },
		IndentBlanklineChar = { fg = p.bg1, fmt = "nocombine" },
		IndentBlanklineContextChar = { fg = p.fg2, fmt = "nocombine" },
		IndentBlanklineContextStart = { sp = p.fg2, fmt = "underline" },
		IndentBlanklineContextSpaceChar = { fmt = "nocombine" },

		-- Indent Blankline v3
		IblIndent = { fg = p.bg1, fmt = "nocombine" },
		IblWhitespace = { fg = p.fg2, fmt = "nocombine" },
		IblScope = { fg = p.fg2, fmt = "nocombine" },

		-- Mini
		MiniCompletionActiveParameter = { fmt = "underline" },

		MiniCursorword = { fmt = "underline" },
		MiniCursorwordCurrent = { fmt = "underline" },

		MiniIndentscopeSymbol = { fg = p.fg2 },
		MiniIndentscopePrefix = { fmt = "nocombine" }, -- Make it invisible

		MiniJump = { fg = c.purple, fmt = "underline", sp = c.purple },

		MiniJump2dSpot = { fg = c.red, fmt = "bold,nocombine" },

		MiniStarterCurrent = { fmt = "nocombine" },
		MiniStarterFooter = { fg = c.dark_red, fmt = "italic" },
		MiniStarterHeader = { fg = c.yellow },
		MiniStarterInactive = { fg = p.fg2 }, -- comments
		MiniStarterItem = { fg = p.fg0, bg = cfg.transparent and c.none or p.bg0 },
		MiniStarterItemBullet = { fg = p.fg2 },
		MiniStarterItemPrefix = { fg = c.yellow },
		MiniStarterSection = { fg = p.fg1 },
		MiniStarterQuery = { fg = c.cyan },

		MiniStatuslineDevinfo = { fg = p.fg0, bg = p.bg2 },
		MiniStatuslineFileinfo = { fg = p.fg0, bg = p.bg2 },
		MiniStatuslineFilename = { fg = p.fg2, bg = p.bg1 },
		MiniStatuslineInactive = { fg = p.fg2, bg = p.bg0 },
		MiniStatuslineModeCommand = { fg = p.bg0, bg = c.yellow, fmt = "bold" },
		MiniStatuslineModeInsert = { fg = p.bg0, bg = c.blue, fmt = "bold" },
		MiniStatuslineModeNormal = { fg = p.bg0, bg = c.green, fmt = "bold" },
		MiniStatuslineModeOther = { fg = p.bg0, bg = c.cyan, fmt = "bold" },
		MiniStatuslineModeReplace = { fg = p.bg0, bg = c.red, fmt = "bold" },
		MiniStatuslineModeVisual = { fg = p.bg0, bg = c.purple, fmt = "bold" },

		MiniSurround = { fg = p.bg0, bg = c.orange },

		MiniTablineCurrent = { fmt = "bold" },
		MiniTablineFill = { fg = p.fg2, bg = p.bg1 },
		MiniTablineHidden = { fg = p.fg0, bg = p.bg1 },
		MiniTablineModifiedCurrent = { fg = c.orange, fmt = "bold,italic" },
		MiniTablineModifiedHidden = { fg = p.fg1, bg = p.bg1, fmt = "italic" },
		MiniTablineModifiedVisible = { fg = c.yellow, bg = p.bg0, fmt = "italic" },
		MiniTablineTabpagesection = { fg = p.bg0, bg = c.bg_yellow },
		MiniTablineVisible = { fg = p.fg1, bg = p.bg0 },

		MiniTestEmphasis = { fmt = "bold" },
		MiniTestFail = { fg = c.red, fmt = "bold" },
		MiniTestPass = { fg = c.green, fmt = "bold" },

		MiniTrailspace = { bg = c.red },

		-- Langs

		-- C
		cInclude = { fg = c.blue },
		cStorageClass = { fg = c.purple },
		cTypedef = { fg = c.purple },
		cDefine = { fg = c.cyan },
		cTSInclude = { fg = c.blue },
		cTSConstant = { fg = c.cyan },
		cTSConstMacro = { fg = c.purple },
		cTSOperator = { fg = c.purple },

		-- C++
		cppStatement = { fg = c.purple, fmt = "bold" },
		cppTSInclude = { fg = c.blue },
		cppTSConstant = { fg = c.cyan },
		cppTSConstMacro = { fg = c.purple },
		cppTSOperator = { fg = c.purple },

		-- Markdown
		markdownBlockquote = { fg = p.fg2 },
		markdownBold = { fg = c.none, fmt = "bold" },
		markdownBoldDelimiter = { fg = p.fg2 },
		markdownCode = { fg = c.green },
		markdownCodeBlock = { fg = c.green },
		markdownCodeDelimiter = { fg = c.yellow },
		markdownH1 = { fg = c.red, fmt = "bold" },
		markdownH2 = { fg = c.purple, fmt = "bold" },
		markdownH3 = { fg = c.orange, fmt = "bold" },
		markdownH4 = { fg = c.red, fmt = "bold" },
		markdownH5 = { fg = c.purple, fmt = "bold" },
		markdownH6 = { fg = c.orange, fmt = "bold" },
		markdownHeadingDelimiter = { fg = p.fg2 },
		markdownHeadingRule = { fg = p.fg2 },
		markdownId = { fg = c.yellow },
		markdownIdDeclaration = { fg = c.red },
		markdownItalic = { fg = c.none, fmt = "italic" },
		markdownItalicDelimiter = { fg = p.fg2, fmt = "italic" },
		markdownLinkDelimiter = { fg = p.fg2 },
		markdownLinkText = { fg = c.red },
		markdownLinkTextDelimiter = { fg = p.fg2 },
		markdownListMarker = { fg = c.red },
		markdownOrderedListMarker = { fg = c.red },
		markdownRule = { fg = c.purple },
		markdownUrl = { fg = c.blue, fmt = "underline" },
		markdownUrlDelimiter = { fg = p.fg2 },
		markdownUrlTitleDelimiter = { fg = c.green },

		-- Php
		phpFunctions = { fg = p.fg0 }, -- functions
		phpMethods = { fg = c.cyan },
		phpStructure = { fg = c.purple },
		phpOperator = { fg = c.purple },
		phpMemberSelector = { fg = p.fg0 },
		phpVarSelector = { fg = c.orange }, -- variables
		phpIdentifier = { fg = c.orange }, -- variables
		phpBoolean = { fg = c.cyan },
		phpNumber = { fg = c.orange },
		phpHereDoc = { fg = c.green },
		phpNowDoc = { fg = c.green },
		phpSCKeyword = { fg = c.purple }, -- keywords
		phpFCKeyword = { fg = c.purple }, -- keywords
		phpRegion = { fg = c.blue },

		-- Scala
		scalaNameDefinition = { fg = p.fg0 },
		scalaInterpolationBoundary = { fg = c.purple },
		scalaInterpolation = { fg = c.purple },
		scalaTypeOperator = { fg = c.red },
		scalaOperator = { fg = c.red },
		scalaKeywordModifier = { fg = c.red }, -- keywords

		-- Tex
		latexTSInclude = { fg = c.blue },
		latexTSFuncMacro = { fg = p.fg0 }, -- functions
		latexTSEnvironment = { fg = c.cyan, fmt = "bold" },
		latexTSEnvironmentName = { fg = c.yellow },
		texCmdEnv = { fg = c.cyan },
		texEnvArgName = { fg = c.yellow },
		latexTSTitle = { fg = c.green },
		latexTSType = { fg = c.blue },
		latexTSMath = { fg = c.orange },
		texMathZoneX = { fg = c.orange },
		texMathZoneXX = { fg = c.orange },
		texMathDelimZone = { fg = p.fg1 },
		texMathDelim = { fg = c.purple },
		texMathOper = { fg = c.red },
		texCmd = { fg = c.purple },
		texCmdPart = { fg = c.blue },
		texCmdPackage = { fg = c.blue },
		texPgfType = { fg = c.yellow },

		-- Vim
		vimOption = { fg = c.red },
		vimSetEqual = { fg = c.yellow },
		vimMap = { fg = c.purple },
		vimMapModKey = { fg = c.orange },
		vimNotation = { fg = c.red },
		vimMapLhs = { fg = p.fg0 },
		vimMapRhs = { fg = c.blue },
		vimVar = { fg = p.fg0 }, -- variables
		vimCommentTitle = { fg = p.fg1 }, -- comments
	}

	local lsp_kind_icons_color = {
		Default = c.purple,
		Array = c.yellow,
		Boolean = c.orange,
		Class = c.yellow,
		Color = p.lavender,
		Constant = c.orange,
		Constructor = c.blue,
		Enum = c.purple,
		EnumMember = c.yellow,
		Event = c.yellow,
		Field = c.purple,
		File = c.blue,
		Folder = c.orange,
		Function = c.blue,
		Interface = p.lavender,
		Key = c.cyan,
		Keyword = c.cyan,
		Method = c.blue,
		Module = c.orange,
		Namespace = c.red,
		Null = p.fg2,
		Number = c.orange,
		Object = c.red,
		Operator = c.red,
		Package = c.yellow,
		Property = c.cyan,
		Reference = c.orange,
		Snippet = c.red,
		String = p.lavender,
		Struct = c.purple,
		Text = p.fg1,
		TypeParameter = c.red,
		Unit = c.green,
		Value = c.orange,
		Variable = c.purple,
	}

	for kind, color in pairs(lsp_kind_icons_color) do
		highlights["CmpItemKind" .. kind] = { fg = color, fmt = cfg.cmp_itemkind_reverse and "reverse" or nil }
		highlights["Aerial" .. kind .. "Icon"] = { fg = color }
		highlights["NavicIcons" .. kind] = { fg = color }
	end

	if cfg.highlights then
		for key, value in pairs(cfg.highlights) do
			highlights[key] = value
		end
	end

	apply(highlights)
end

function M.setup()
	local palette = require("keeper.krbon.onedark")
	local config = require("keeper.krbon.config")
	local util = require("keeper.krbon.util")

	---@type KrbonHighlightGroups
	local highlights = {
		-- Backgrounds base color
		["Normal"] = { fg = palette.grey07, bg = config.transparent and palette.none or palette.grey00 },
		["NormalFloat"] = { "Normal", bg = config.float_transparent and palette.none or palette.grey01 },

		-- Vim
		["ColorColumn"] = { bg = palette.grey01 },
		["Conceal"] = { fg = palette.grey03 },
		["Cursor"] = { fg = palette.grey00, bg = palette.grey06 },
		["lCursor"] = { "Cursor" },
		["CursorIM"] = { "Cursor" },
		["CursorColumn"] = { bg = palette.grey02 },
		["CursorLine"] = { bg = palette.grey02 },
		["Directory"] = { fg = palette.light_cyan },
		["DiffAdd"] = { bg = palette.dark_green },
		["DiffChange"] = { bg = palette.dark_blue },
		["DiffDelete"] = { bg = palette.dark_red },
		["DiffText"] = { bg = palette.dark_grey },
		["EndOfBuffer"] = { fg = palette.grey03 },
		["TermCursor"] = { "Cursor" },
		["TermCursorNC"] = { "Cursor" },
		["ErrorMsg"] = { fg = palette.light_red },
		["VertSplit"] = { fg = palette.grey03 },
		["Folded"] = { bg = palette.grey02 },
		["FoldColumn"] = { fg = palette.grey04 },
		["SignColumn"] = { "FoldColumn" },
		["IncSearch"] = { "CurSearch" },
		["Substitute"] = { fg = palette.accent, fmt = "underline" },
		["LineNr"] = { fg = palette.grey04 },
		["LineNrAbove"] = { "LineNr" },
		["LineNrBelow"] = { "LineNr" },
		["CursorLineNr"] = { fg = palette.accent },
		["CursorLineFold"] = { fg = palette.grey03 },
		["CursorLineSign"] = { "CursorLineFold" },
		["MatchParen"] = { fg = palette.accent, fmt = "underline" },
		["ModeMsg"] = { fg = palette.lavender },
		["MsgArea"] = { fg = palette.grey07 },
		["MsgSeparator"] = { fg = palette.grey06 },
		["MoreMsg"] = { fg = palette.accent, fmt = "bold" },
		["NonText"] = { fg = palette.grey04 },
		["FloatBorder"] = { "NormalFloat", fg = palette.accent },
		["FloatTitle"] = { "NormalFloat", fg = palette.grey07 },
		["NormalNC"] = { "Normal" },
		["Pmenu"] = { "NormalFloat", fg = palette.grey07 },
		["PmenuSel"] = { "NormalFloat", fg = palette.accent },
		["PmenuKind"] = { "Pmenu" },
		["PmenuKindSel"] = { "PmenuSel" },
		["PmenuExtra"] = { "Pmenu" },
		["PmenuExtraSel"] = { "PmenuSel" },
		["PmenuSbar"] = { "Pmenu" },
		["PmenuThumb"] = { bg = palette.grey02 },
		["Question"] = { fg = palette.light_cyan },
		["QuickFixLine"] = { "Question" },
		["Search"] = { "CurSearch" },
		["SpecialKey"] = { fg = palette.grey04 },
		["SpellBad"] = { "SpecialKey", fmt = "undercurl" },
		["SpellCap"] = { "SpecialKey", fmt = "undercurl" },
		["SpellLocal"] = { "SpecialKey", fmt = "undercurl" },
		["SpellRare"] = { "SpecialKey", fmt = "undercurl" },
		["StatusLine"] = { "NormalFloat", fg = palette.grey07 },
		["StatusLineNC"] = { "StatusLine" },
		["TabLine"] = { "NormalFloat", fg = palette.grey07 },
		["TabLineFill"] = { "TabLine" },
		["TabLineSel"] = { "NormalFloat", fg = palette.accent },
		["Title"] = { fg = palette.grey07 },
		["Visual"] = { bg = palette.grey03 },
		["VisualNOS"] = { "Visual" },
		["WarningMsg"] = { fg = palette.light_yellow },
		["Whitespace"] = { fg = palette.grey04 },
		["Winseparator"] = { fg = palette.grey06 },
		["WildMenu"] = { "NormalFloat", fg = palette.accent },
		["WinBar"] = { fg = palette.grey06 },
		["WinBarNC"] = { fg = palette.grey06 },

		["Comment"] = { fg = palette.grey04, fmt = "italic" },

		["Constant"] = { fg = palette.lavender },
		["String"] = { fg = palette.lavender },
		["Character"] = { "String" },
		["Number"] = { fg = palette.light_blue },
		["Boolean"] = { fg = palette.salmon_pink },
		["Float"] = { "Number" },

		["Identifier"] = { fg = palette.salmon_pink },
		["Function"] = { fg = palette.pink },

		["Statement"] = { fg = palette.reddish_blue },
		["Conditional"] = { "Statement" },
		["Repeat"] = { "Statement" },
		["Label"] = { "Statement" },
		["Operator"] = { fg = palette.grey07 },
		["Keyword"] = { "Statement" },
		["Exception"] = { "Statement" },

		["PreProc"] = { fg = palette.cyan },
		["Include"] = { "PreProc" },
		["Define"] = { "PreProc" },
		["Macro"] = { "PreProc" },
		["PreCondit"] = { "PreProc" },

		["Type"] = { "Statement" },
		["StorageClass"] = { "Statement" },
		["Structure"] = { "Statement" },
		["Typedef"] = { "Statement" },

		["Special"] = { fg = palette.blue },
		["SpecialChar"] = { fg = palette.blue },
		["Tag"] = { fg = palette.blue },
		["Delimiter"] = { fg = palette.grey07 },
		["SpecialComment"] = { fg = palette.light_cyan },
		["Debug"] = { fg = palette.emerald },

		["Underlined"] = { fmt = "underline" },
		["Ignore"] = {},
		["Error"] = { fg = palette.light_red },
		["Todo"] = { fg = palette.emerald },

		["LspReferenceText"] = { fg = palette.accent },
		["LspReferenceRead"] = { "LspReferenceText" },
		["LspReferenceWrite"] = { "LspReferenceText" },
		["LspCodeLens"] = { fg = palette.grey04 },
		["LspCodeLensSeparator"] = { fg = palette.grey04 },
		["LspSignatureActiveParameter"] = { fg = palette.light_cyan },

		["DiagnosticError"] = { fg = palette.light_red },
		["DiagnosticWarn"] = { fg = palette.light_yellow },
		["DiagnosticInfo"] = { fg = palette.grey07 },
		["DiagnosticHint"] = { fg = palette.pink },
		["DiagnosticOk"] = { fg = palette.light_green },
		["DiagnosticVirtualTextError"] = { fg = util.darken(palette.light_red, 0.35) },
		["DiagnosticVirtualTextWarn"] = { fg = util.darken(palette.light_yellow, 0.35) },
		["DiagnosticVirtualTextInfo"] = { fg = util.darken(palette.grey07, 0.35) },
		["DiagnosticVirtualTextHint"] = { fg = util.darken(palette.pink, 0.35) },
		["DiagnosticVirtualTextOk"] = { fg = util.darken(palette.light_green, 0.35) },
		["DiagnosticUnderlineError"] = { fmt = "undercurl", sp = palette.light_red },
		["DiagnosticUnderlineWarn"] = { fmt = "undercurl", sp = palette.light_yellow },
		["DiagnosticUnderlineInfo"] = { fmt = "undercurl", sp = palette.grey07 },
		["DiagnosticUnderlineHint"] = { fmt = "undercurl", sp = palette.pink },
		["DiagnosticUnderlineOk"] = { fmt = "undercurl", sp = palette.light_green },

		["@text.literal"] = { fg = palette.grey07 },
		["@text.reference"] = { fg = palette.grey07 },
		["@text.title"] = { fg = palette.salmon_pink },
		["@text.uri"] = { fg = palette.lavender, fmt = "underline" },
		["@text.underline"] = { fg = palette.salmon_pink, fmt = "underline" },
		["@text.todo"] = { fg = palette.grey07 },
		["@comment"] = { "Comment" },
		["@punctuation"] = { fg = palette.grey07 },
		["@constant"] = { "Constant" },
		["@constant.builtin"] = { "PreProc" },
		["@constant.macro"] = { "Macro" },
		["@define"] = { "Define" },
		["@macro"] = { "Macro" },
		["@string"] = { "String" },
		["@string.escape"] = { fg = palette.light_blue },
		["@string.special"] = { fg = palette.grey06 },
		["@character"] = { "Character" },
		["@character.special"] = { fg = palette.grey06 },
		["@number"] = { "Number" },
		["@boolean"] = { "Boolean" },
		["@float"] = { "Float" },
		["@function"] = { fg = palette.pink },
		["@function.builtin"] = { fg = palette.pink },
		["@function.macro"] = { "Macro" },
		["@parameter"] = { "Identifier" },
		["@method"] = { fg = palette.light_blue },
		["@field"] = { "Identifier" },
		["@property"] = { "Identifier" },
		["@constructor"] = { fg = palette.grey05 },
		["@conditional"] = { "Statement" },
		["@repeat"] = { "Statement" },
		["@label"] = { fg = palette.light_blue },
		["@operator"] = { "Operator" },
		["@keyword"] = { "Keyword" },
		["@exception"] = { fg = palette.light_blue },
		["@variable"] = { fg = palette.grey07 },
		["@type"] = { "Statement" },
		["@type.definition"] = { "Statement" },
		["@storageclass"] = { "Statement" },
		["@structure"] = { "Structure" },
		["@namespace"] = { fg = palette.cyan },
		["@include"] = { "Statement" },
		["@preproc"] = { "PreProc" },
		["@debug"] = { "Debug" },
		["@tag"] = { "Statement" },

		["Added"] = { fg = palette.light_green },
		["Changed"] = { fg = palette.light_blue },
		["Removed"] = { fg = palette.light_red },

		["StatusLineNormal"] = { fg = palette.grey00, bg = palette.reddish_blue },
		["StatusLineInsert"] = { fg = palette.grey00, bg = palette.pink },
		["StatusLineVisual"] = { fg = palette.grey00, bg = palette.lavender },
		["StatusLineCommand"] = { fg = palette.grey00, bg = palette.emerald },
		["StatusLineReplace"] = { fg = palette.grey00, bg = palette.salmon_pink },
		["StatusLineTerminal"] = { fg = palette.grey00, bg = palette.grey07 },

		["TelescopeNormal"] = { "NormalFloat" },
		["TelescopeMatching"] = { fg = palette.accent },
		["TelescopeTitle"] = { "NormalFloat" },
		["TelescopeBorder"] = { "FloatBorder" },
		["TelescopePromptBorder"] = { "FloatBorder" },
		["TelescopePreviewBorder"] = { "FloatBorder" },
		["TelescopeResultsBorder"] = { "FloatBorder" },

		["DashboardHeader"] = { fg = palette.lavender },
		["DashboardFooter"] = { fg = palette.salmon_pink },
		["DashboardIcon"] = { fg = palette.light_blue },

		["Decorator"] = { fg = palette.pink },

		["@variable.builtin"] = { "Identifier" },
		["@type.builtin"] = { "Statement" },
		["@punctuation.special"] = { fg = palette.light_cyan },
		["@keyword.coroutine"] = { "Statement" },

		["@lsp.type.class"] = { "Structure" },
		["@lsp.type.decorator"] = { "Decorator" },
		["@lsp.type.function"] = { "@function" },
		["@lsp.type.macro"] = { "Macro" },
		["@lsp.type.method"] = { "@function" },
		["@lsp.type.struct"] = { "Structure" },
		["@lsp.type.type"] = { "Type" },
		["@lsp.type.typeParameter"] = { "Typedef" },
		["@lsp.type.selfParameter"] = { "@variable.builtin" },
		["@lsp.type.builtinConstant"] = { "@constant.builtin" },
		["@lsp.type.magicFunction"] = { "@function.builtin" },
		["@lsp.type.boolean"] = { "@boolean" },
		["@lsp.type.builtinType"] = { "@type.builtin" },
		["@lsp.type.comment"] = { "@comment" },
		["@lsp.type.enum"] = { "@type" },
		["@lsp.type.enumMember"] = { "@constant" },
		["@lsp.type.escapeSequence"] = { "@string.escape" },
		["@lsp.type.formatSpecifier"] = { "@punctuation.special" },
		["@lsp.type.keyword"] = { "@keyword" },
		["@lsp.type.namespace"] = { "@namespace" },
		["@lsp.type.number"] = { "@number" },
		["@lsp.type.operator"] = { "@operator" },
		["@lsp.type.parameter"] = { "@parameter" },
		["@lsp.type.property"] = { "@property" },
		["@lsp.type.selfKeyword"] = { fg = palette.emerald },
		["@lsp.type.string.rust"] = { "@string" },
		["@lsp.type.typeAlias"] = { "@type.definition" },
		["@lsp.type.unresolvedReference"] = { "Error" },
		["@lsp.type.variable"] = { "@variable" },
		["@lsp.mod.readonly"] = { "@constant" },
		["@lsp.mod.typeHint"] = { "Type" },
		["@lsp.mod.builtin"] = { "Special" },
		["@lsp.typemod.class.defaultLibrary"] = { "@type.builtin" },
		["@lsp.typemod.enum.defaultLibrary"] = { "@type.builtin" },
		["@lsp.typemod.enumMember.defaultLibrary"] = { "@constant.builtin" },
		["@lsp.typemod.function.defaultLibrary"] = { "@function.builtin" },
		["@lsp.typemod.keyword.async"] = { "@keyword.coroutine" },
		["@lsp.typemod.macro.defaultLibrary"] = { "@function.builtin" },
		["@lsp.typemod.method.defaultLibrary"] = { "@function.builtin" },
		["@lsp.typemod.operator.injected"] = { "@operator" },
		["@lsp.typemod.string.injected"] = { "@string" },
		["@lsp.typemod.operator.controlFlow"] = { "@exception" },
		["@lsp.typemod.keyword.documentation"] = { "Special" },
		["@lsp.typemod.variable.global"] = { "@constant" },
		["@lsp.typemod.variable.static"] = { "@constant" },
		["@lsp.typemod.function.builtin"] = { "@function.builtin" },
		["@lsp.typemod.function.readonly"] = { "@method" },
		["@lsp.typemod.variable.defaultLibrary"] = { "@variable.builtin" },
		["@lsp.typemod.variable.injected"] = { "@variable" },
	}

	if config.highlights then
		for key, value in pairs(config.highlights) do
			highlights[key] = value
		end
	end

	apply(highlights)
end

return M
