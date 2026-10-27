-- Muted purple dark colorscheme.
--
-- A calm, low-contrast palette designed for long coding sessions.
-- The theme uses dark purple backgrounds, soft lavender syntax colors,
-- and muted accent colors to distinguish code without overwhelming the editor.
--
-- This file defines the colorscheme directly through Neovim highlight groups.
-- It does not require an external colorscheme plugin.

-- Terminal and background settings
-- Enable true-color support so Neovim can display the palette's exact RGB
-- colors.
vim.opt.termguicolors = true

-- Tell Neovim that the intended colorscheme uses a dark background.
vim.opt.background = "dark"

-- Clear existing highlight definitions before applying the theme.
-- This helps prevent highlight settings from a previously loaded colorscheme
-- from interfering with Sei's definitions.
vim.cmd("highlight clear")

-- Register the colorscheme name.
-- This allows Neovim and other plugins to identify the active colorscheme.
vim.g.colors_name = "sei"

-- Color palette
-- Keep colors centralized so the appearance of the theme can be adjusted
-- without editing every highlight group individually.
local c = {
	-- Backgrounds
	-- Main editor, alternate surfaces, floating windows, selections, and
	-- borders.
	bg = "#191621",
	bg_alt = "#211D2B",
	bg_float = "#252130",
	selection = "#393047",
	border = "#393344",

	-- Foreground
	-- Primary text, secondary text, and subdued UI elements.
	fg = "#D4C9E8",
	fg_dim = "#B1A6C4",
	muted = "#82778F",

	-- Syntax
	-- Accent colors used to distinguish language constructs and code elements.
	purple = "#B9A0E8",
	lavender = "#C4B4E8",
	pink = "#CDA6B8",
	green = "#A8BCA0",
	yellow = "#D7B887",
	blue = "#9EAFD0",
	cyan = "#9FBDBB",
	red = "#D49AAB",

	-- Git
	-- Colors for added, changed, and deleted lines.
	git_add = "#9BB99A",
	git_change = "#C9B080",
	git_delete = "#C98F9F",
}

-- Highlight groups
-- Each entry associates a Neovim highlight group with foreground, background,
-- and optional style attributes such as bold or italic.
--
-- Foreground (fg) controls text color.
-- Background (bg) controls the color behind text.
-- Other attributes can control emphasis, such as bold, italic, or undercurl.
local groups = {

	-- Editor
	-- Main text areas, cursor line, line numbers, selections, and separators.
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
	-- Status line, tab line, and completion-menu appearance.
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
	-- Traditional Vim syntax groups used to color language constructs.
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
	-- Highlight groups used for errors, warnings, informational messages,
	-- hints, and successful diagnostic states.
	DiagnosticError = { fg = c.red },
	DiagnosticWarn = { fg = c.yellow },
	DiagnosticInfo = { fg = c.blue },
	DiagnosticHint = { fg = c.cyan },
	DiagnosticOk = { fg = c.green },

	-- Underline diagnostic locations without changing their text foreground.
	-- The special (sp) attribute defines the underline color.
	DiagnosticUnderlineError = { undercurl = true, sp = c.red },
	DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
	DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
	DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan },

	-- Give inline diagnostic messages a subtle background for readability.
	DiagnosticVirtualTextError = { fg = c.red, bg = c.bg_alt },
	DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.bg_alt },
	DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.bg_alt },
	DiagnosticVirtualTextHint = { fg = c.cyan, bg = c.bg_alt },

	-- Git diff
	-- Highlight added, changed, and deleted lines in diff views.
	DiffAdd = { fg = c.git_add, bg = c.bg_alt },
	DiffChange = { fg = c.git_change, bg = c.bg_alt },
	DiffDelete = { fg = c.git_delete, bg = c.bg_alt },
	DiffText = { fg = c.fg, bg = c.selection },

	-- LSP references
	-- Highlight occurrences of the symbol under the cursor when the LSP
	-- client reports reference locations.
	LspReferenceText = { bg = c.selection },
	LspReferenceRead = { bg = c.selection },
	LspReferenceWrite = { bg = c.selection },

	-- Treesitter captures
	-- These groups provide syntax colors when a parser or plugin uses
	-- Neovim's Treesitter-based highlighting system.
	-- The @ prefix identifies a Treesitter capture name.
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

-- Apply highlight groups
-- Iterate over the palette definitions and register each group with Neovim.
-- Using namespace 0 applies these as global highlight definitions.
for group, opts in pairs(groups) do
	vim.api.nvim_set_hl(0, group, opts)
end

-- File explorer
-- Define highlight groups used by nvim-tree.
-- These settings keep the explorer visually consistent with the main editor.
-- The colors are written explicitly here to match the palette above.
vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = "#D4C9E8", bg = "#191621" })
vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { fg = "#D4C9E8", bg = "#191621" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = "#191621", bg = "#191621" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#393344", bg = "#191621" })

-- Use purple accents to distinguish folders and opened directories.
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#B9A0E8" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#C4B4E8", bold = true })

-- Use the theme's Git colors for new and modified files.
vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = "#A8BCA0" })
vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = "#D7B887" })
