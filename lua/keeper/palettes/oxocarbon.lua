local none = "NONE"

local greys = {
	"#161616",
	"#1D1D1D",
	"#404040",
	"#5C5C5C",
	"#D5D5D5",
	"#EAEAEA",
	"#FFFFFF",
}

local colors = {
	"#08BDBA",
	"#3DDBD9",
	"#78A9FF",
	"#EE5396",
	"#33B1FF",
	"#FF7EB6",
	"#42BE65",
	"#BE95FF",
	"#82CFFF",

	"#37474F",
	"#90A4AE",
	"#525252",
	"#FF6F00",
	"#0F62FE",
	"#673AB7",
	"#FFAB91",
}

local diff = {
	add = "#122F2F",
	change = "#222A39",
	text = "#2F3F5C",
	delete = "#361C28",
}

local grey = "#ADADAD"

local dark = {
	base00 = greys[1],
	base01 = greys[2],
	base02 = greys[3],
	base03 = greys[4],
	base04 = greys[5],
	base05 = greys[6],
	base06 = greys[7],
	base07 = colors[1],
	base08 = colors[2],
	base09 = colors[3],
	base10 = colors[4],
	base11 = colors[5],
	base12 = colors[6],
	base13 = colors[7],
	base14 = colors[8],
	base15 = colors[9],
	none = none,
}

local oxocarbon = dark

local hlgroups = {
	-- editor
	["ColorColumn"] = { fg = oxocarbon.none, bg = oxocarbon.base01 },
	["Cursor"] = { fg = oxocarbon.base00, bg = oxocarbon.base04 },
	["CursorLine"] = { fg = oxocarbon.none, bg = oxocarbon.base01 },
	["CursorColumn"] = { fg = oxocarbon.none, bg = oxocarbon.base01 },
	["CursorLineNr"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["QuickFixLine"] = { fg = oxocarbon.none, bg = oxocarbon.base01 },
	["Error"] = { fg = oxocarbon.base10, bg = oxocarbon.base01 },
	["LineNr"] = { fg = oxocarbon.base03, bg = oxocarbon.base00 },
	["NonText"] = { fg = oxocarbon.base02, bg = oxocarbon.none },
	["Normal"] = { fg = oxocarbon.base04, bg = oxocarbon.base00 },
	["Pmenu"] = { fg = oxocarbon.base04, bg = oxocarbon.base01 },
	["PmenuSbar"] = { fg = oxocarbon.base04, bg = oxocarbon.base01 },
	["PmenuSel"] = { fg = oxocarbon.base08, bg = oxocarbon.base02 },
	["PmenuThumb"] = { fg = oxocarbon.base08, bg = oxocarbon.base02 },
	["SpecialKey"] = { fg = oxocarbon.base03, bg = oxocarbon.none },
	["Visual"] = { fg = oxocarbon.none, bg = oxocarbon.base02 },
	["VisualNOS"] = { fg = oxocarbon.none, bg = oxocarbon.base02 },
	["TooLong"] = { fg = oxocarbon.none, bg = oxocarbon.base02 },
	["Debug"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["Macro"] = { fg = oxocarbon.base07, bg = oxocarbon.none },
	["MatchParen"] = { fg = oxocarbon.none, bg = oxocarbon.base02, gui = "underline" },
	["Bold"] = { fg = oxocarbon.none, bg = oxocarbon.none, gui = "bold" },
	["Italic"] = { fg = oxocarbon.none, bg = oxocarbon.none, gui = "italic" },
	["Underlined"] = { fg = oxocarbon.none, bg = oxocarbon.none, gui = "underline" },

	-- diagnostics
	["DiagnosticWarn"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["DiagnosticError"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["DiagnosticInfo"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["DiagnosticHint"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["DiagnosticUnderlineWarn"] = { fg = oxocarbon.base14, bg = oxocarbon.none, gui = "undercurl" },
	["DiagnosticUnderlineError"] = { fg = oxocarbon.base10, bg = oxocarbon.none, gui = "undercurl" },
	["DiagnosticUnderlineInfo"] = { fg = oxocarbon.base04, bg = oxocarbon.none, gui = "undercurl" },
	["DiagnosticUnderlineHint"] = { fg = oxocarbon.base04, bg = oxocarbon.none, gui = "undercurl" },

	-- health
	["HealthError"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["HealthWarning"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["HealthSuccess"] = { fg = oxocarbon.base13, bg = oxocarbon.none },

	-- ledger
	["@text.literal.commodity"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["@number.date"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["@number.date.effective"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["@number.interval"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["@number.status"] = { fg = oxocarbon.base12, bg = oxocarbon.none },
	["@number.quantity"] = { fg = oxocarbon.base11, bg = oxocarbon.none },
	["@number.quantity.negative"] = { fg = oxocarbon.base10, bg = oxocarbon.none },

	-- lsp
	["LspReferenceText"] = { fg = oxocarbon.none, bg = oxocarbon.base03 },
	["LspReferenceread"] = { fg = oxocarbon.none, bg = oxocarbon.base03 },
	["LspReferenceWrite"] = { fg = oxocarbon.none, bg = oxocarbon.base03 },
	["LspSignatureActiveParameter"] = { fg = oxocarbon.base08, bg = oxocarbon.none },

	-- lps-semantic-tokens
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
	["@lsp.type.selfKeyword"] = { "@variable.builtin" },
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

	-- gutter
	["Folded"] = { fg = oxocarbon.base02, bg = oxocarbon.base01 },
	["FoldColumn"] = { fg = oxocarbon.base01, bg = oxocarbon.base00 },
	["SignColumn"] = { fg = oxocarbon.base01, bg = oxocarbon.base00 },

	-- navigation
	["Directory"] = { fg = oxocarbon.base08, bg = oxocarbon.none },

	-- prompts
	["EndOfBuffer"] = { fg = oxocarbon.base01, bg = oxocarbon.none },
	["ErrorMsg"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["ModeMsg"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["MoreMsg"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["Question"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["Substitute"] = { fg = oxocarbon.base01, bg = oxocarbon.base08 },
	["WarningMsg"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["WildMenu"] = { fg = oxocarbon.base08, bg = oxocarbon.base01 },

	-- vimhelp
	["helpHyperTextJump"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["helpSpecial"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["helpHeadline"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["helpHeader"] = { fg = oxocarbon.base15, bg = oxocarbon.none },

	-- diff
	["DiffAdded"] = { fg = oxocarbon.base07, bg = oxocarbon.none },
	["DiffChanged"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["DiffRemoved"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["DiffAdd"] = { bg = diff.add, fg = oxocarbon.none },
	["DiffChange"] = { bg = diff.change, fg = oxocarbon.none },
	["DiffText"] = { bg = diff.text, fg = oxocarbon.none },
	["DiffDelete"] = { bg = diff.delete, fg = oxocarbon.none },

	-- search
	["IncSearch"] = { fg = oxocarbon.base06, bg = oxocarbon.base10 },
	["Search"] = { fg = oxocarbon.base01, bg = oxocarbon.base08 },

	-- tabs
	["TabLine"] = { "StatusLineNC" },
	["TabLineFill"] = { "TabLine" },
	["TabLineSel"] = { "StatusLine" },

	-- window
	["Title"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["VertSplit"] = { fg = oxocarbon.base01, bg = oxocarbon.base00 },

	-- regular syntax
	["Boolean"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Character"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["Comment"] = { fg = oxocarbon.base03, bg = oxocarbon.none, gui = "italic" },
	["Conceal"] = { fg = oxocarbon.none, bg = oxocarbon.none },
	["Conditional"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Constant"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["Decorator"] = { fg = oxocarbon.base12, bg = oxocarbon.none },
	["Define"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Delimeter"] = { fg = oxocarbon.base06, bg = oxocarbon.none },
	["Exception"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Float"] = { "Number" },
	["Function"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["Identifier"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["Include"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Keyword"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Label"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Number"] = { fg = oxocarbon.base15, bg = oxocarbon.none },
	["Operator"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["PreProc"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Repeat"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Special"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["SpecialChar"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["SpecialComment"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["Statement"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["StorageClass"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["String"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["Structure"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Tag"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["Todo"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["Type"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["Typedef"] = { fg = oxocarbon.base09, bg = oxocarbon.none },

	-- markdown
	["markdownBlockquote"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["markdownBold"] = { "Bold" },
	["markdownItalic"] = { "Italic" },
	["markdownBoldItalic"] = { fg = oxocarbon.none, bg = oxocarbon.none, gui = "bold,italic" },
	["markdownRule"] = { "Comment" },
	["markdownH1"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["markdownH2"] = { "markdownH1" },
	["markdownH3"] = { "markdownH1" },
	["markdownH4"] = { "markdownH1" },
	["markdownH5"] = { "markdownH1" },
	["markdownH6"] = { "markdownH1" },
	["markdownUrl"] = { fg = oxocarbon.base14, bg = oxocarbon.none, gui = "underline" },
	["markdownHeadingDelimiter"] = { "markdownH1" },
	["markdownHeadingRule"] = { "markdownH1" },
	["markdownCode"] = { "String" },
	["markdownCodeBlock"] = { "markdownCode" },
	["markdownCodeDelimiter"] = { "markdownCode" },
	["markdownListMarker"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["markdownOrderedListMarker"] = { fg = oxocarbon.base08, bg = oxocarbon.none },

	-- asciidoc
	["asciidocAttributeEntry"] = { fg = oxocarbon.base15, bg = oxocarbon.none },
	["asciidocAttributeList"] = { "asciidocAttributeEntry" },
	["asciidocAttributeRef"] = { "asciidocAttributeEntry" },
	["asciidocHLabel"] = { "markdownH1" },
	["asciidocOneLineTitle"] = { "markdownH1" },
	["asciidocQuotedMonospaced"] = { "markdownBlockquote" },
	["asciidocURL"] = { "markdownUrl" },

	-- [[ treesitter ]]

	-- misc
	["@comment"] = { "Comment" },
	["@error"] = { fg = oxocarbon.base11, bg = oxocarbon.none },
	["@operator"] = { "Operator" },

	-- punctuation
	["@punctuation.delimiter"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["@punctuation.bracket"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["@punctuation.special"] = { fg = oxocarbon.base08, bg = oxocarbon.none },

	-- literals
	["@string"] = { "String" },
	["@string.regex"] = { fg = oxocarbon.base07, bg = oxocarbon.none },
	["@string.escape"] = { fg = oxocarbon.base15, bg = oxocarbon.none },

	-- @string.special
	["@character"] = { "Character" },

	-- @character.special
	["@boolean"] = { "Boolean" },
	["@number"] = { "Number" },
	["@float"] = { "Float" },

	-- functions
	["@function"] = { fg = oxocarbon.base12, bg = oxocarbon.none, gui = "bold" },
	["@function.builtin"] = { fg = oxocarbon.base12, bg = oxocarbon.none },

	-- @function.call
	["@function.macro"] = { fg = oxocarbon.base07, bg = oxocarbon.none },
	["@method"] = { fg = oxocarbon.base07, bg = oxocarbon.none },

	-- @method.call
	["@constructor"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["@parameter"] = { fg = oxocarbon.base04, bg = oxocarbon.none },

	-- keywords
	["@keyword"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["@keyword.function"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["@keyword.operator"] = { fg = oxocarbon.base08, bg = oxocarbon.none },

	-- @keyword.return
	["@conditional"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["@repeat"] = { fg = oxocarbon.base09, bg = oxocarbon.none },

	-- @debug
	["@label"] = { fg = oxocarbon.base15, bg = oxocarbon.none },
	["@include"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["@exception"] = { fg = oxocarbon.base15, bg = oxocarbon.none },

	-- types
	["@type"] = { "Type" },
	["@type.builtin"] = { "Type" },

	-- @type.defintion
	-- @type.qualifier
	-- @storageclass
	-- @storageclass.lifetime
	["@attribute"] = { fg = oxocarbon.base15, bg = oxocarbon.none },
	["@field"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["@property"] = { fg = oxocarbon.base10, bg = oxocarbon.none },

	-- identifiers
	["@variable"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["@variable.builtin"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["@constant"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["@constant.builtin"] = { fg = oxocarbon.base07, bg = oxocarbon.none },
	["@constant.macro"] = { fg = oxocarbon.base07, bg = oxocarbon.none },
	["@namespace"] = { fg = oxocarbon.base07, bg = oxocarbon.none },
	["@symbol"] = { fg = oxocarbon.base15, bg = oxocarbon.none, gui = "bold" },

	-- text
	["@text"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["@text.strong"] = { fg = oxocarbon.none, bg = oxocarbon.none },
	["@text.emphasis"] = { fg = oxocarbon.base10, bg = oxocarbon.none, gui = "bold" },
	["@text.underline"] = { fg = oxocarbon.base10, bg = oxocarbon.none, gui = "underline" },
	["@text.strike"] = { fg = oxocarbon.base10, bg = oxocarbon.none, gui = "strikethrough" },
	["@text.title"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["@text.literal"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["@text.uri"] = { fg = oxocarbon.base14, bg = oxocarbon.none, gui = "underline" },

	-- @text.math
	-- @text.environment
	-- @text.environment.name
	-- @text.reference
	-- @text.todo
	-- @text.note
	-- @text.warning
	-- @text.danger
	-- @text.diff.add
	-- @text.diff.delete
	-- tags
	["@tag"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["@tag.attribute"] = { fg = oxocarbon.base15, bg = oxocarbon.none },
	["@tag.delimiter"] = { fg = oxocarbon.base15, bg = oxocarbon.none },

	-- Conceal
	-- @conceal
	-- Spell
	-- @spell
	-- @nospell
	-- non-standard
	-- @variable.global
	-- locals
	-- @definition
	-- @definition.constant
	-- @definition.function
	-- @definition.method
	-- @definition.var
	-- @definition.parameter
	-- @definition.macro
	-- @definition.type
	-- @definition.field
	-- @definition.enum
	-- @definition.namespace
	-- @definition.import
	-- @definition.associated
	-- @scope
	["@reference"] = { fg = oxocarbon.base04, bg = oxocarbon.none },

	-- neovim
	["NvimInternalError"] = { fg = oxocarbon.base00, bg = oxocarbon.base08 },
	["NormalFloat"] = { fg = oxocarbon.base05, bg = oxocarbon.base00 },
	["FloatBorder"] = { fg = oxocarbon.base05, bg = oxocarbon.base00 },
	["NormalNC"] = { fg = oxocarbon.base05, bg = oxocarbon.base00 },
	["TermCursor"] = { fg = oxocarbon.base00, bg = oxocarbon.base04 },
	["TermCursorNC"] = { fg = oxocarbon.base00, bg = oxocarbon.base04 },

	-- statusline/winbar
	["StatusLine"] = { fg = oxocarbon.base04, bg = oxocarbon.base00 },
	["StatusLineNC"] = { fg = oxocarbon.base04, bg = oxocarbon.base01 },
	["StatusReplace"] = { fg = oxocarbon.base00, bg = oxocarbon.base08 },
	["StatusInsert"] = { fg = oxocarbon.base00, bg = oxocarbon.base12 },
	["StatusVisual"] = { fg = oxocarbon.base00, bg = oxocarbon.base14 },
	["StatusTerminal"] = { fg = oxocarbon.base00, bg = oxocarbon.base11 },
	["StatusNormal"] = { fg = oxocarbon.base00, bg = oxocarbon.base15 },
	["StatusCommand"] = { fg = oxocarbon.base00, bg = oxocarbon.base13 },
	["StatusLineDiagnosticWarn"] = { fg = oxocarbon.base14, bg = oxocarbon.base00, gui = "bold" },
	["StatusLineDiagnosticError"] = { fg = oxocarbon.base10, bg = oxocarbon.base00, gui = "bold" },

	-- telescope
	["TelescopeBorder"] = { fg = oxocarbon.base03, bg = oxocarbon.base00 },
	["TelescopePromptBorder"] = { fg = oxocarbon.base03, bg = oxocarbon.base00 },
	["TelescopePromptNormal"] = { fg = oxocarbon.base03, bg = oxocarbon.base00 },
	["TelescopePromptPrefix"] = { fg = oxocarbon.base08, bg = oxocarbon.base00 },
	["TelescopeNormal"] = { fg = oxocarbon.none, bg = oxocarbon.base00 },
	["TelescopePreviewTitle"] = { fg = oxocarbon.base05, bg = oxocarbon.base00 },
	["TelescopePromptTitle"] = { fg = oxocarbon.base05, bg = oxocarbon.base00 },
	["TelescopeResultsTitle"] = { fg = oxocarbon.base05, bg = oxocarbon.base00 },
	["TelescopeSelection"] = { fg = oxocarbon.none, bg = oxocarbon.base02 },
	["TelescopePreviewLine"] = { fg = oxocarbon.none, bg = oxocarbon.base01 },
	["TelescopeMatching"] = { fg = oxocarbon.base08, bg = oxocarbon.none, gui = "bold,italic" },

	-- notify
	["NotifyERRORBorder"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["NotifyWARNBorder"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["NotifyINFOBorder"] = { fg = oxocarbon.base05, bg = oxocarbon.none },
	["NotifyDEBUGBorder"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["NotifyTRACEBorder"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["NotifyERRORIcon"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["NotifyWARNIcon"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["NotifyINFOIcon"] = { fg = oxocarbon.base05, bg = oxocarbon.none },
	["NotifyDEBUGIcon"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["NotifyTRACEIcon"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["NotifyERRORTitle"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["NotifyWARNTitle"] = { fg = oxocarbon.base14, bg = oxocarbon.none },
	["NotifyINFOTitle"] = { fg = oxocarbon.base05, bg = oxocarbon.none },
	["NotifyDEBUGTitle"] = { fg = oxocarbon.base13, bg = oxocarbon.none },
	["NotifyTRACETitle"] = { fg = oxocarbon.base13, bg = oxocarbon.none },

	-- cmp
	["CmpItemAbbr"] = { fg = grey, bg = oxocarbon.none },
	["CmpItemAbbrMatch"] = { fg = oxocarbon.base05, bg = oxocarbon.none, gui = "bold" },
	["CmpItemAbbrMatchFuzzy"] = { fg = oxocarbon.base04, bg = oxocarbon.none, gui = "bold" },
	["CmpItemMenu"] = { fg = oxocarbon.base04, bg = oxocarbon.none, gui = "italic" },
	["CmpItemKindInterface"] = { fg = oxocarbon.base08, bg = oxocarbon.base01 },
	["CmpItemKindColor"] = { fg = oxocarbon.base08, bg = oxocarbon.base01 },
	["CmpItemKindTypeParameter"] = { fg = oxocarbon.base08, bg = oxocarbon.base01 },
	["CmpItemKindText"] = { fg = oxocarbon.base09, bg = oxocarbon.base01 },
	["CmpItemKindEnum"] = { fg = oxocarbon.base09, bg = oxocarbon.base01 },
	["CmpItemKindKeyword"] = { fg = oxocarbon.base09, bg = oxocarbon.base01 },
	["CmpItemKindConstant"] = { fg = oxocarbon.base10, bg = oxocarbon.base01 },
	["CmpItemKindConstructor"] = { fg = oxocarbon.base10, bg = oxocarbon.base01 },
	["CmpItemKindReference"] = { fg = oxocarbon.base10, bg = oxocarbon.base01 },
	["CmpItemKindFunction"] = { fg = oxocarbon.base11, bg = oxocarbon.base01 },
	["CmpItemKindStruct"] = { fg = oxocarbon.base11, bg = oxocarbon.base01 },
	["CmpItemKindClass"] = { fg = oxocarbon.base11, bg = oxocarbon.base01 },
	["CmpItemKindModule"] = { fg = oxocarbon.base11, bg = oxocarbon.base01 },
	["CmpItemKindOperator"] = { fg = oxocarbon.base11, bg = oxocarbon.base01 },
	["CmpItemKindField"] = { fg = oxocarbon.base12, bg = oxocarbon.base01 },
	["CmpItemKindProperty"] = { fg = oxocarbon.base12, bg = oxocarbon.base01 },
	["CmpItemKindEvent"] = { fg = oxocarbon.base12, bg = oxocarbon.base01 },
	["CmpItemKindUnit"] = { fg = oxocarbon.base13, bg = oxocarbon.base01 },
	["CmpItemKindSnippet"] = { fg = oxocarbon.base13, bg = oxocarbon.base01 },
	["CmpItemKindFolder"] = { fg = oxocarbon.base13, bg = oxocarbon.base01 },
	["CmpItemKindVariable"] = { fg = oxocarbon.base14, bg = oxocarbon.base01 },
	["CmpItemKindFile"] = { fg = oxocarbon.base14, bg = oxocarbon.base01 },
	["CmpItemKindMethod"] = { fg = oxocarbon.base15, bg = oxocarbon.base01 },
	["CmpItemKindValue"] = { fg = oxocarbon.base15, bg = oxocarbon.base01 },
	["CmpItemKindEnumMember"] = { fg = oxocarbon.base15, bg = oxocarbon.base01 },

	-- nvimtree
	["NvimTreeImageFile"] = { fg = oxocarbon.base12, bg = oxocarbon.none },
	["NvimTreeFolderIcon"] = { fg = oxocarbon.base12, bg = oxocarbon.none },
	["NvimTreeWinSeparator"] = { fg = oxocarbon.base00, bg = oxocarbon.base00 },
	["NvimTreeFolderName"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["NvimTreeIndentMarker"] = { fg = oxocarbon.base02, bg = oxocarbon.none },
	["NvimTreeEmptyFolderName"] = { fg = oxocarbon.base15, bg = oxocarbon.none },
	["NvimTreeOpenedFolderName"] = { fg = oxocarbon.base15, bg = oxocarbon.none },
	["NvimTreeNormal"] = { fg = oxocarbon.base04, bg = oxocarbon.base00 },

	-- neogit
	["NeogitBranch"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["NeogitRemote"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["NeogitHunkHeader"] = { fg = oxocarbon.base04, bg = oxocarbon.base02 },
	["NeogitHunkHeaderHighlight"] = { fg = oxocarbon.base04, bg = oxocarbon.base03 },

	-- hydra
	["HydraRed"] = { fg = oxocarbon.base12, bg = oxocarbon.none },
	["HydraBlue"] = { fg = oxocarbon.base09, bg = oxocarbon.none },
	["HydraAmaranth"] = { fg = oxocarbon.base10, bg = oxocarbon.none },
	["HydraTeal"] = { fg = oxocarbon.base08, bg = oxocarbon.none },
	["HydraHint"] = { fg = oxocarbon.none, bg = oxocarbon.base00 },

	-- alpha
	["alpha1"] = { fg = oxocarbon.base03, bg = oxocarbon.none },
	["alpha2"] = { fg = oxocarbon.base04, bg = oxocarbon.none },
	["alpha3"] = { fg = oxocarbon.base03, bg = oxocarbon.none },

	-- headlines.nvim
	["CodeBlock"] = { fg = oxocarbon.none, bg = oxocarbon.base01 },

	-- nvim-bufferline
	["BufferLineDiagnostic"] = { fg = oxocarbon.base10, bg = oxocarbon.none, gui = "bold" },
	["BufferLineDiagnosticVisible"] = { fg = oxocarbon.base10, bg = oxocarbon.none, gui = "bold" },

	-- preservim/vim-markdown
	["htmlH1"] = { "markdownH1" },
	["mkdRule"] = { "markdownRule" },
	["mkdListItem"] = { "markdownListMarker" },
	["mkdListItemCheckbox"] = { "markdownListMarker" },

	-- vimwiki/vimwiki
	["VimwikiHeader1"] = { "markdownH1" },
	["VimwikiHeader2"] = { "markdownH1" },
	["VimwikiHeader3"] = { "markdownH1" },
	["VimwikiHeader4"] = { "markdownH1" },
	["VimwikiHeader5"] = { "markdownH1" },
	["VimwikiHeader6"] = { "markdownH1" },
	["VimwikiHeaderChar"] = { "markdownH1" },
	["VimwikiList"] = { "markdownListMarker" },
	["VimwikiLink"] = { "markdownUrl" },
	["VimwikiCode"] = { "markdownCode" },
}

require("keeper.colors").apply(hlgroups)
