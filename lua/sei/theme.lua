-- sei: muted purple dark theme
-- Calm colors for long coding sessions.

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.cmd("highlight clear")
vim.g.colors_name = "sei"

local c = {
	-- Backgrounds
	bg = "#191621",
	bg_alt = "#211D2B",
	bg_float = "#252130",
	selection = "#393047",
	border = "#393344",

	-- Foreground
	fg = "#D4C9E8",
	fg_dim = "#B1A6C4",
	muted = "#82778F",

	-- Syntax
	purple = "#B9A0E8",
	lavender = "#C4B4E8",
	pink = "#CDA6B8",
	green = "#A8BCA0",
	yellow = "#D7B887",
	blue = "#9EAFD0",
	cyan = "#9FBDBB",
	red = "#D49AAB",

	-- Git
	git_add = "#9BB99A",
	git_change = "#C9B080",
	git_delete = "#C98F9F",
}

local groups = {
	-- Editor
	Normal = { fg = c.fg, bg = c.bg },
	NormalNC = { fg = c.fg_dim, bg = c.bg },
	NormalFloat = { fg = c.fg, bg = c.bg_float },
	FloatBorder = { fg = c.border, bg = c.bg_float },
	EndOfBuffer = { fg = c.bg_alt },
	SignColumn = { bg = c.bg },
	CursorLine = { bg = c.bg_alt },
	CursorLineNr = { fg = c.lavender, bold = true },
	LineNr = { fg = c.muted },
	ColorColumn = { bg = c.bg_alt },
	Visual = { bg = c.selection },
	Search = { fg = c.bg, bg = c.yellow },
	IncSearch = { fg = c.bg, bg = c.purple },
	MatchParen = { fg = c.lavender, bold = true },
	WinSeparator = { fg = c.border },
	VertSplit = { fg = c.border },

	-- Status line and menus
	StatusLine = { fg = c.fg, bg = c.bg_float },
	StatusLineNC = { fg = c.muted, bg = c.bg_alt },
	TabLine = { fg = c.muted, bg = c.bg_alt },
	TabLineSel = { fg = c.fg, bg = c.bg },
	TabLineFill = { bg = c.bg_alt },
	Pmenu = { fg = c.fg, bg = c.bg_float },
	PmenuSel = { fg = c.fg, bg = c.selection },
	PmenuSbar = { bg = c.bg_alt },
	PmenuThumb = { bg = c.muted },

	-- Syntax
	Comment = { fg = c.muted, italic = true },
	Constant = { fg = c.pink },
	String = { fg = c.green },
	Character = { fg = c.green },
	Number = { fg = c.pink },
	Boolean = { fg = c.purple },
	Identifier = { fg = c.fg },
	Function = { fg = c.lavender },
	Statement = { fg = c.purple },
	Conditional = { fg = c.purple },
	Repeat = { fg = c.purple },
	Label = { fg = c.blue },
	Operator = { fg = c.fg_dim },
	Keyword = { fg = c.purple },
	Exception = { fg = c.purple },
	PreProc = { fg = c.pink },
	Include = { fg = c.purple },
	Define = { fg = c.purple },
	Type = { fg = c.blue },
	StorageClass = { fg = c.purple },
	Structure = { fg = c.blue },
	Typedef = { fg = c.blue },
	Special = { fg = c.cyan },
	SpecialComment = { fg = c.muted, italic = true },
	Error = { fg = c.red },
	Todo = { fg = c.yellow, bold = true },

	-- Diagnostics
	DiagnosticError = { fg = c.red },
	DiagnosticWarn = { fg = c.yellow },
	DiagnosticInfo = { fg = c.blue },
	DiagnosticHint = { fg = c.cyan },
	DiagnosticOk = { fg = c.green },
	DiagnosticUnderlineError = { undercurl = true, sp = c.red },
	DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
	DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
	DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan },
	DiagnosticVirtualTextError = { fg = c.red, bg = c.bg_alt },
	DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.bg_alt },
	DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.bg_alt },
	DiagnosticVirtualTextHint = { fg = c.cyan, bg = c.bg_alt },

	-- Git diff
	DiffAdd = { fg = c.git_add, bg = c.bg_alt },
	DiffChange = { fg = c.git_change, bg = c.bg_alt },
	DiffDelete = { fg = c.git_delete, bg = c.bg_alt },
	DiffText = { fg = c.fg, bg = c.selection },

	-- Floating documentation
	LspReferenceText = { bg = c.selection },
	LspReferenceRead = { bg = c.selection },
	LspReferenceWrite = { bg = c.selection },

	-- Common Treesitter captures
	["@variable"] = { fg = c.fg },
	["@function"] = { fg = c.lavender },
	["@function.call"] = { fg = c.lavender },
	["@keyword"] = { fg = c.purple },
	["@keyword.return"] = { fg = c.purple },
	["@string"] = { fg = c.green },
	["@type"] = { fg = c.blue },
	["@type.builtin"] = { fg = c.blue },
	["@constant"] = { fg = c.pink },
	["@comment"] = { fg = c.muted, italic = true },
	["@property"] = { fg = c.fg_dim },
	["@punctuation"] = { fg = c.fg_dim },
}

for group, opts in pairs(groups) do
	vim.api.nvim_set_hl(0, group, opts)
end

-- File explorer
vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = "#D4C9E8", bg = "#191621" })
vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { fg = "#D4C9E8", bg = "#191621" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = "#191621", bg = "#191621" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#393344", bg = "#191621" })
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#B9A0E8" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#C4B4E8", bold = true })
vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = "#A8BCA0" })
vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = "#D7B887" })
