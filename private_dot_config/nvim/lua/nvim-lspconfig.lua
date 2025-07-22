-- don't display diagnostic in virtual_text
--  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--    vim.lsp.diagnostic.on_publish_diagnostics, {
--      virtual_text = false,
--    }
--  )
vim.diagnostic.config({
  signs = {
    enable = true,
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.HINT] = '󰝥',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.WARN] = ''
    },
  },
  virtual_text = false,
  update_in_insert = false,
  underline = true,
  severity_sort = true
})

-- Setup language servers.
local lspconfig = require("lspconfig")
-- lspconfig.denols.setup{}
-- lspconfig.lua_ls.setup({})
lspconfig.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}

lspconfig.denols.setup({})
lspconfig.cssls.setup({})
lspconfig.taplo.setup({})
lspconfig.marksman.setup({})
lspconfig.typos_lsp.setup({})

-- Server-specific settings. See ":help lspconfig-setup"

-- Global mappings.
-- See ":help vim.diagnostic.*" for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "diagnostic in float" })
vim.keymap.set("n", "<space>dp",
  function()
    vim.diagnostic.jump({ count = 1 })
  end,
  { desc = "go to prev diagnostics" })
vim.keymap.set("n", "<space>dn",
  function()
    vim.diagnostic.jump({ count = -1 })
  end,
  { desc = "go to next diagnostics" })
-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "setloclist" })

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
    vim.keymap.set("n", "<space>gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "show declaration" })
    vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "show definition" })
    vim.keymap.set("n", "<space>K", vim.lsp.buf.hover, { buffer = bufnr, desc = "hovering" })
    vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "show implementation" })
    vim.keymap.set("n", "<space>k", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "show signature_help" })
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "add workspace folder" })
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder,
      { buffer = bufnr, desc = "remove workspace folder" })
    vim.keymap.set("n", "<space>wl",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = bufnr, desc = "show workspace folders list" })
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "show type definition" })
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "rename" })
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code_action" })
    vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "go to references" })
    vim.keymap.set("n", "<space>fo",
    function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = "format" })
  end,
})
