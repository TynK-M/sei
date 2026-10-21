-- Go language server
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			staticcheck = true,
			analyses = {
				unusedparams = true,
				shadow = false,
			},
		},
	},
})

vim.lsp.enable("gopls")

-- Language-server keymaps, available only for attached buffers
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("SeiLspKeymaps", {
		clear = true,
	}),
	callback = function(event)
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, {
				buffer = event.buf,
				silent = true,
				desc = desc,
			})
		end

		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gr", vim.lsp.buf.references, "Find references")
		map("K", vim.lsp.buf.hover, "Show documentation")

		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")

		-- Navigate diagnostics
		map("[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous diagnostic")

		map("]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
	end,
})

-- Format Go files on save using gopls
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("SeiGoFormat", {
		clear = true,
	}),
	pattern = "*.go",
	callback = function(event)
		vim.lsp.buf.format({
			bufnr = event.buf,
			timeout_ms = 3000,
			filter = function(client)
				return client.name == "gopls"
			end,
		})
	end,
})
