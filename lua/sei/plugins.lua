local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if it is not installed
if not vim.uv.fs_stat(lazypath) then
	local result = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		error("Failed to install lazy.nvim:\n" .. result)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- LSP server configurations
	{
		"neovim/nvim-lspconfig",
		lazy = false,
	},

	-- Git change indicators in the sign column
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},

	-- Telescope for ripgrep and find
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search file contents" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Search help" },
			{ "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Search commands" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = "  ",
					selection_caret = "▎ ",
					path_display = { "truncate" },
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						width = 0.85,
						height = 0.80,
					},
					border = true,
				},
			})
		end,
	},

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		},
		config = function()
			vim.g.loaded_netrw = 1

			require("nvim-tree").setup({
				hijack_cursor = true,
				sync_root_with_cwd = true,
				respect_buf_cwd = true,

				view = {
					width = 32,
					side = "left",
				},

				renderer = {
					group_empty = true,
					indent_markers = {
						enable = true,
					},
					icons = {
						show = {
							git = true,
							file = true,
							folder = true,
							folder_arrow = true,
						},
					},
				},

				filters = {
					dotfiles = false,
				},

				git = {
					enable = true,
					ignore = false,
				},

				actions = {
					open_file = {
						quit_on_open = false,
						resize_window = true,
					},
				},
			})
		end,
	},
})
