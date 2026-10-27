-- This configuration uses Neovim's built-in LSP support.

-- vim.lsp.config() defines the configuration used when Neovim starts gopls.
-- The settings table contains options passed to the language server.
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			-- Enable staticcheck analyses to report additional code issues.
			staticcheck = true,
			-- Configure individual gopls analyses.
			analyses = {
				-- Report function parameters that are never used.
				unusedparams = true,

				-- Do not report variable shadowing.
				shadow = false,
			},
		},
	},
})

-- Enable gopls for buffers where Neovim detects a suitable Go project.
-- The gopls executable must be installed and available in PATH.
vim.lsp.enable("gopls")

-- LSP keymaps
-- Register key mappings when a language server attaches to a buffer.
-- LspAttach is triggered when an LSP client connects to a buffer.
-- This ensures that these mappings are available only where LSP features
-- can be used, rather than globally in every buffer.
vim.api.nvim_create_autocmd("LspAttach", {
	-- Create a dedicated augroup so these autocmds can be managed together.
	-- clear = true removes previous autocmds in this group when re-created,
	-- preventing duplicate registrations if this file is sourced again.
	group = vim.api.nvim_create_augroup("SeiLspKeymaps", {
		clear = true,
	}),

	callback = function(event)
		-- Define a helper for creating normal-mode, buffer-local LSP mappings.
		-- event.buf identifies the buffer to which the language server
		-- attached.
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, {
				buffer = event.buf,
				silent = true,
				desc = desc,
			})
		end

		-- Navigation

		-- Jump to the definition of the symbol under the cursor.
		map("gd", vim.lsp.buf.definition, "Go to definition")

		-- Find references to the symbol under the cursor.
		map("gr", vim.lsp.buf.references, "Find references")

		-- Display documentation for the symbol under the cursor.
		map("K", vim.lsp.buf.hover, "Show documentation")

		-- Refactoring and code actions

		-- Rename a symbol throughout the locations supported by the LSP.
		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")

		-- Request available code actions, such as quick fixes or refactoring.
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")

		-- Diagnostics

		-- Display diagnostic information for the current cursor position.
		map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")

		-- Move to the previous diagnostic and display its details.
		map("[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous diagnostic")

		-- Move to the next diagnostic and display its details.
		map("]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
	end,
})

-- Format Go files on save
-- Format Go source files automatically before they are written to disk.
-- BufWritePre runs immediately before a buffer is saved.
vim.api.nvim_create_autocmd("BufWritePre", {
	-- Keep formatting behavior in its own augroup.
	-- clear = true prevents duplicate autocmds if this file is reloaded.
	group = vim.api.nvim_create_augroup("SeiGoFormat", {
		clear = true,
	}),

	-- Apply this autocmd only to Go source files.
	pattern = "*.go",

	callback = function(event)
		-- Request formatting for the buffer being saved.
		vim.lsp.buf.format({
			bufnr = event.buf,

			-- Stop waiting for the formatting response after three seconds.
			timeout_ms = 3000,

			-- Use gopls as the formatting provider.
			-- This avoids selecting a different attached LSP client.
			filter = function(client)
				return client.name == "gopls"
			end,
		})
	end,
})
