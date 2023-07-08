local M = {}

function M.setup()
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	local null_ls = require("null-ls")
	null_ls.setup({
		-- you can reuse a shared lspconfig on_attach callback here
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
						-- vim.lsp.buf.formatting_sync()
					end,
				})
			end
		end,
		sources = {
			null_ls.builtins.formatting.stylua, -- can be installed globally using: brew install stylua
			null_ls.builtins.code_actions.eslint_d, -- can be installed globally using: npm install -g eslint_d
			null_ls.builtins.formatting.prettier, -- installed on a per-project basis using: yarn add -D prettier
			-- can consider upgrading to prettierd: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#prettierd
		},
	})
end

return M
