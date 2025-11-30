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

-- you dont need if you use ddc_source_lsp_setup... maybe
-- vim.lsp.config("*", {
--   capabilities = require("ddc_source_lsp").make_client_capabilities(),
-- })
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

local  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
-- Global mappings.
-- See ":help vim.diagnostic.*" for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "diagnostic in float" })
vim.keymap.set("n", "<space>dp", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "go to prev diagnostics" })
vim.keymap.set("n", "<space>dn",
  function()
    vim.diagnostic.jump({ count = -1 })
  end, { desc = "go to next diagnostics" })
-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "setloclist" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See ":help vim.lsp.*" for documentation on any of the below functions
    local bufnr = ev.buf
    local opt = { width = 60, height = 30, max_width = 80, max_height = 56, border = "single", silent = true }
    vim.keymap.set("n", "<space>gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "show declaration" })
    vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "show definition" })
    vim.keymap.set("n", "<space>K",
      function()
        return vim.lsp.buf.hover(opt)
      end,
      { buffer = bufnr, desc = "hovering" }
    )
    vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "show implementation" })
    vim.keymap.set("n", "<space>k",
      function()
        return vim.lsp.buf.signature_help(opt)
      end,
      { buffer = bufnr, desc = "show signature_help" }
    )
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "add workspace folder" })
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder,
      { buffer = bufnr, desc = "remove workspace folder" })
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = bufnr, desc = "show workspace folders list" })
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "show type definition" })
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "rename" })
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code_action" })
    vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "go to references" })
    vim.keymap.set("n", "<space>fo", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = "format" })
  end,
})

-- nvim builtin lsp.signature_help
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = group,
  callback = function(lsp)
    local client = vim.lsp.get_client_by_id(lsp.data.client_id)
    if client:supports_method("textDocument/signatureHelp") then
      vim.api.nvim_create_autocmd("CursorMovedI", {
        callback = function()
          vim.lsp.buf.signature_help({

            width = 60,
            height = 30,
            max_width = 80,
            max_height = 56,
            focusable = false,
            border = "single",
            silent = true
          })
        end
      })
    end
  end,
  desc = "auto signature_help"
})

-- LspProgress
vim.api.nvim_create_autocmd('LspProgress', {
  group = group,
  callback = function(lsp)
    local value = lsp.data.params.value
    local client_name = vim.lsp.get_client_by_id(lsp.data.client_id).name
    local echo_opt = {
      id = vim.api.nvim_echo({}, false, {}),
      kind = "progress",
      title = value.title,
      status = "running",
      -- percent = value.percentage or 0
    }
    local msg = value.message or "complete"
    if value.kind == 'begin' then
      vim.api.nvim_echo({
        { "[" .. client_name .. "]", "Statement" },
        { " " .. msg }
      }, true, echo_opt)
    elseif value.kind == 'report' then
      vim.api.nvim_echo({
        { "[" .. client_name .. "]", "Statement" },
        { " " .. msg }
      }, true, echo_opt)
    elseif value.kind == 'end' then
      echo_opt.status = "success"
      vim.api.nvim_echo({
        { "[" .. client_name .. "]", "Statement" },
        { " " .. msg }
      }, true, echo_opt)
    end
  end,
})
-- vim.lsp.enable("lua_ls")
vim.lsp.enable("vimls")
vim.lsp.enable("emmylua_ls")
vim.lsp.enable("denols")
vim.lsp.enable("cssls")
-- vim.lsp.enable("taplo")
vim.lsp.enable("tombi")
vim.lsp.enable("marksman")
vim.lsp.enable("typos_lsp")
