-- おまじない
vim.loader.enable()

-- dvpm setup
local denops = vim.fn.expand("~/.cache/nvim/dvpm/github.com/vim-denops/denops.vim")
if not vim.loop.fs_stat(denops) then
	vim.fn.system({ "git", "clone", "https://github.com/vim-denops/denops.vim", denops })
end
vim.opt.runtimepath:prepend(denops)

-- set global options
vim.api.nvim_set_var("loaded_netrw", 1)
vim.api.nvim_set_var("loaded_netrwPlugin", 1)
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmenu = false
vim.opt.wildoptions = ""
vim.opt.helplang = "ja"
vim.opt.termguicolors = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.completeopt = { "menu", "preview", "noselect" }
vim.opt.fileencoding = "utf-8"
vim.opt.signcolumn = "yes"
vim.opt.clipboard:append{'unnamedplus'}
vim.opt.guicursor = {
  'i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
  'n-v-c:block-Cursor',
  'r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100'
}
-- vim.opt.cmdheight = 1
vim.opt.winblend = 0
vim.opt.pumblend = 15

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

-- local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

require("ddu-keymap")
-- require("help-float")
