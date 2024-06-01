-- Setup language servers.
local lspconfig = require("lspconfig")
-- don't display diagnostic in virtual_text
--  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--    vim.lsp.diagnostic.on_publish_diagnostics, {
--      virtual_text = false,
--    }
--  )
-- lspconfig.denols.setup{}
lspconfig.lua_ls.setup({})
lspconfig.cssls.setup({})
lspconfig.taplo.setup({})
lspconfig.marksman.setup({})
-- Server-specific settings. See ":help lspconfig-setup"

-- Global mappings.
-- See ":help vim.diagnostic.*" for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "diagnostic in float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "go to prev diagnostics" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "go to next diagnostics" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "setloclist" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	  callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		-- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See ":help vim.lsp.*" for documentation on any of the below functions
		  local bufnr = ev.buf
		  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "show declaration" })
		  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "show definition" })
		  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "hovering"})
		  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "show implementation"})
		  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "show signature_help" })
		  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "add workspace folder"})
		  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "remove workspace folder"})
		  vim.keymap.set("n", "<space>wl", function()
	  		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		  end, { buffer = bufnr, desc = "show workspace folders list"})
		  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "show type definition"})
		  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "rename"})
		  vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code_action"})
		  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "go to references" })
		  vim.keymap.set("n", "<space>f", function()
			  vim.lsp.buf.format({ async = true })
		  end, { buffer = bufnr, desc = "format"})
	end,
})
