local opt = vim.opt

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers and cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 5
opt.sidescrolloff = 5

-- Indentation and tabs
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Spaces per indentation level
opt.tabstop = 4 -- Display width of a tab character
opt.softtabstop = 4 -- Spaces inserted/deleted with Tab and Backspace
opt.smartindent = true -- Indent new lines based on simple syntax rules
opt.breakindent = true -- Preserve indentation when wrapped lines continue

-- Search
opt.ignorecase = true -- Case-insensitive search by default
opt.smartcase = true -- Case-sensitive if the query contains uppercase

-- Editing and files
opt.undofile = true -- Persist undo history between sessions
opt.undolevels = 1000 -- Keep a useful undo history
opt.autowrite = false -- Never save files implicitly when changing buffers
opt.confirm = true -- Confirm before abandoning unsaved changes

-- Window behavior
opt.splitright = true -- Open vertical splits to the right
opt.splitbelow = true -- Open horizontal splits below
opt.wrap = false -- Keep long code lines on one line
opt.linebreak = true -- Break at word boundaries if wrapping is enabled

-- TUI
opt.showmode = false -- Mode is omitted from the command line
opt.laststatus = 2 -- Always show the status line
opt.ruler = true -- Show cursor position
opt.signcolumn = "yes" -- Keep diagnostics and Git signs aligned
opt.list = true -- Display selected whitespace characters
opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}
opt.mouse = "a" -- Allow mouse interaction
opt.updatetime = 250 -- Faster diagnostic and Git sign updates
opt.timeoutlen = 400 -- Shorter wait for mapped key sequences

-- Clipboard
opt.clipboard = "unnamedplus" -- Share clipboard with the system

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
	},
})
