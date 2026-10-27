-- The <leader> key is a configurable prefix for custom mappings.
-- Its value depends on the configuration; Sei's default is space.

-- Store vim.keymap.set in a local variable to keep the mapping concise.
local map = vim.keymap.set

-- Editing

-- Basic shortcuts for clearing search highlights, saving files, and quitting.
-- <Esc> clears the highlight left behind by a search without changing the
-- search pattern itself.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save the current buffer to its file.
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })

-- Quit the current window. Neovim may refuse if there are unsaved changes.
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- Window navigation
-- Use Ctrl + h/j/k/l to move between windows.
-- These keys corresponds to left, down, up, and right, respectively.
-- They are useful when working with multiple splits.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Splits

-- Create a new window by splitting the current one vertically or
-- horizontally.
-- A vertical split places windows side by side.
-- A horizontal split places one window above the other.
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Resize all windows in the current tab page to equal dimensions.
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })

-- ]q moves to the next item; [q moves to the previous item.
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })

-- Open or close the quickfix window.
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- Visual-mode indentation
-- Indent the selected lines to the left or right.
-- The gv command reselects the previous visual selection, keeping the
-- selection active after indentation so the operation can be repeated.
map("v", "<", "<gv")
map("v", ">", ">gv")
