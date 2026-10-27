-- Neovim options and general editor behavior.
--
-- This file defines the default behavior of the editor, including indentation,
-- navigation, searching, window layout, the terminal interface, clipboard
-- integration, and diagnostic display.

-- Most settings use vim.opt, which provides an interface for configuring
-- Neovim options from Lua.
local opt = vim.opt

-- Leader keys

-- The leader key acts as a prefix for custom keyboard mappings.
-- A space is used to keep custom shortcuts easy to reach.
-- For example, <leader>w becomes Space followed by w.
vim.g.mapleader = " "

-- The local leader is intended for mappings specific to a filetype or buffer.
-- It is set to the same key as the global leader for consistency.
vim.g.maplocalleader = " "

-- Line numbers and cursor

-- Show the absolute line number of the current line.
opt.number = true

-- Show relative line numbers for all other lines.
-- Relative numbers make commands such as 5j and 3k useful for navigation.
opt.relativenumber = true

-- Highlight the line containing the cursor.
opt.cursorline = true

-- Always reserve space for signs, such as diagnostics and Git changes.
-- Keeping this column visible prevents text from shifting when signs appear.
opt.signcolumn = "yes"

-- Keep at least five screen lines visible above and below the cursor when
-- possible, providing context while navigating through the file.
opt.scrolloff = 5

-- Keep at least five screen columns visible to the left and right of the
-- cursor when possible.
opt.sidescrolloff = 5

-- Indentation and tabs

-- Insert spaces instead of literal tab characters when using Tab for
-- indenting.
opt.expandtab = true

-- Number of spaces used by each indentation operation.
opt.shiftwidth = 4

-- Number of screen columns occupied by a tab character.
opt.tabstop = 4

-- Number of spaces inserted or removed when pressing Tab or Backspace.
opt.softtabstop = 4

-- Automatically indent new lines based on simple syntax rules.
opt.smartindent = true

-- Preserve indentation when a long line wraps across multiple screen lines.
opt.breakindent = true

-- Search

-- Ignore letter case in searches by default.
opt.ignorecase = true

-- Override ignorecase when the search pattern contains uppercase letters.
-- For example, "error" is case-insensitive, while "Error" is case-sensitive.
opt.smartcase = true

-- Editing and files

-- Save undo history to disk so it can be restored after reopening a file.
opt.undofile = true

-- Retain up to 1000 undo levels.
opt.undolevels = 1000

-- Do not save buffers automatically when switching files or changing windows.
opt.autowrite = false

-- Ask for confirmation when an operation would abandon unsaved changes.
opt.confirm = true

-- Window behavior

-- Open vertical splits to the right of the current window.
opt.splitright = true

-- Open horizontal splits below the current window.
opt.splitbelow = true

-- Do not wrap long lines by default.
-- This is useful when reading source code where line length and alignment
-- matter.
opt.wrap = false

-- If wrapping is enabled, prefer breaking lines at word boundaries.
-- This has no visible effect while wrap is disabled.
opt.linebreak = true

-- Terminal user interface (TUI)

-- Hide Neovim's built-in mode message from the command line.
-- This is commonly used when another UI element displays the current mode.
opt.showmode = false

-- Always display the status line, including when only one window is open.
opt.laststatus = 2

-- Display the current cursor position in the ruler.
opt.ruler = true

-- Display selected whitespace characters to make invisible characters easier
-- to spot while editing.
opt.list = true

-- Define how certain whitespace characters are displayed:
--   »  - Tab character
--   ·  - Trailing space
--   ␣  - Non-breaking space
opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

-- Enable mouse support in Neovim's terminal interface.
opt.mouse = "a"

-- Wait 250 milliseconds before triggering certain CursorHold-related events.
-- A shorter interval can make diagnostic and Git-sign updates feel more responsive.
opt.updatetime = 250

-- Wait 400 milliseconds for the next key in a mapped key sequence.
-- A shorter timeout makes custom mappings feel faster but leaves less time
-- to enter longer sequences.
opt.timeoutlen = 400

-- Clipboard

-- Use the system clipboard for normal yank, delete, and put operations.
-- This requires a working clipboard provider in the environment.
opt.clipboard = "unnamedplus"

-- Diagnostics

-- Configure how Neovim displays diagnostic information from language servers
-- and other diagnostic sources.
vim.diagnostic.config({
	-- Display diagnostic messages inline beside the relevant source code.
	virtual_text = true,

	-- Show diagnostic signs in the sign column.
	signs = true,

	-- Underline source code associated with diagnostics.
	underline = true,

	-- Sort diagnostics by severity so more important issues take precedence.
	severity_sort = true,

	-- Use rounded borders for floating diagnostic windows.
	float = {
		border = "rounded",
	},
})
