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
})
