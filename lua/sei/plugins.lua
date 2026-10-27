-- Plugin manager and plugin configuration.
--
-- This file bootstraps lazy.nvim if it is not installed, adds it to Neovim's
-- runtime path, and defines the plugins used by Sei.
--
-- lazy.nvim manages plugin installation, loading, dependencies, and setup.
-- Plugins can be loaded immediately, when an event occurs, when a command
-- is called, or when a configured key mapping is used.

-- Bootstrap lazy.nvim
-- Determine the directory where lazy.nvim should be installed.
-- stdpath("data") usually resolves to Neovim's user data directory.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check whether lazy.nvim already exists at the expected path.
-- fs_stat() returns file information when the path exists, or nil otherwise.
if not vim.uv.fs_stat(lazypath) then
	-- Clone lazy.nvim from its official repository.
	-- --filter=blob:none reduces the amount of Git data downloaded.
	-- --branch=stable selects the stable branch instead of the default branch.
	-- The final argument specifies the installation directory.
	local result = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})

	-- vim.v.shell_error contains the exit status of the last system command.
	-- Stop initialization if cloning failed, and include Git's output so the
	-- cause of the failure is easier to identify.
	if vim.v.shell_error ~= 0 then
		error("Failed to install lazy.nvim:\n" .. result)
	end
end

-- Add lazy.nvim to Neovim's runtime path so it can be loaded with require().
-- Prepending ensures it is available before plugin setup begins.
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
-- Each entry describes a plugin and optionally defines when it loads,
-- which other plugins it depends on, and how it is configured.
require("lazy").setup({
	-- Language Server Protocol support
	-- nvim-lspconfig provides configurations for many language servers.
	-- Sei configures and enables gopls separately in lsp.lua.
	{
		"neovim/nvim-lspconfig",

		-- Load this plugin during startup rather than waiting for an event.
		lazy = false,
	},

	-- Git change indicators
	-- gitsigns.nvim displays Git changes, such as added, modified, and deleted
	-- lines, in the sign column.
	{
		"lewis6991/gitsigns.nvim",

		-- Load when an existing file is read or a new file is created.
		event = { "BufReadPre", "BufNewFile" },

		-- Use the plugin's default configuration.
		opts = {},
	},

	-- Telescope: fuzzy finding and search
	-- Telescope provides pickers for finding files, searching file contents,
	-- switching buffers, and browsing Neovim help and commands.
	{
		"nvim-telescope/telescope.nvim",

		-- Plenary provides Lua utilities used by Telescope.
		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		-- Load Telescope when its user command is invoked.
		cmd = "Telescope",

		-- Load Telescope when one of these mappings is pressed.
		-- lazy.nvim creates the mappings and loads the plugin when needed.
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search file contents" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Search help" },
			{ "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Search commands" },
		},

		-- Configure Telescope after the plugin has loaded.
		config = function()
			require("telescope").setup({
				defaults = {
					-- Customize the appearance of the search prompt and
					-- selection.
					prompt_prefix = "  ",
					selection_caret = "▎ ",

					-- Shorten displayed paths when they are too long.
					path_display = { "truncate" },

					-- Place the prompt above the results.
					sorting_strategy = "ascending",

					-- Configure the dimensions and layout of the picker.
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						width = 0.85,
						height = 0.80,
					},

					-- Display borders around picker windows.
					border = true,
				},
			})
		end,
	},

	-- File explorer
	-- nvim-tree provides a navigable directory tree inside Neovim.
	{
		"nvim-tree/nvim-tree.lua",

		-- Use the latest release tag rather than tracking an arbitrary commit.
		version = "*",

		-- Load the file explorer during startup.
		lazy = false,

		-- Provides file and folder icons for the explorer.
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		-- Toggle the file explorer with Ctrl+n.
		keys = {
			{ "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		},

		-- Configure nvim-tree after it has loaded.
		config = function()
			-- Disable the built-in netrw file explorer.
			-- This prevents it from conflicting with nvim-tree.
			vim.g.loaded_netrw = 1

			require("nvim-tree").setup({
				-- Keep the cursor behavior aligned with the tree's navigation.
				hijack_cursor = true,

				-- Keep the tree root synchronized with the current working
				-- directory.
				sync_root_with_cwd = true,

				-- Respect the current buffer's working directory when
				-- applicable.
				respect_buf_cwd = true,

				-- Configure the tree window.
				view = {
					width = 32,
					side = "left",
				},

				-- Configure how files and directories are displayed.
				renderer = {
					-- Combine directories that contain only one child
					-- directory.
					group_empty = true,

					-- Show visual markers for directory indentation levels.
					indent_markers = {
						enable = true,
					},

					-- Display icons for files, folders, Git status, and
					-- folder arrows.
					icons = {
						show = {
							git = true,
							file = true,
							folder = true,
							folder_arrow = true,
						},
					},
				},

				-- Show hidden files, such as .gitignore and .env.
				-- Git-ignored files may still be affected by other filter
				-- settings.
				filters = {
					dotfiles = false,
				},

				-- Enable Git status indicators in the tree.
				-- Show ignored files where supported by the tree's Git
				-- integration.
				git = {
					enable = true,
					ignore = false,
				},

				-- Configure what happens when a file is opened from the tree.
				actions = {
					open_file = {
						-- Keep the tree open after opening a file.
						quit_on_open = false,

						-- Allow the tree window to resize when opening files.
						resize_window = true,
					},
				},
			})
		end,
	},
})
