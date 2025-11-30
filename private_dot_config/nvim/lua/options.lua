-- set global options
vim.api.nvim_set_var("loaded_netrw", 1)
vim.api.nvim_set_var("loaded_netrwPlugin", 1)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- cmdline-completion
vim.opt.wildmenu = false
vim.opt.wildoptions = "pum"

-- ins-completion
vim.opt.autocomplete = false
vim.opt.completeopt = { "menu", "preview", "noinsert" }

vim.opt.helplang = "ja"
vim.opt.termguicolors = true
vim.opt.shell = "fish"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
vim.opt.number = true
vim.opt.fileencoding = "utf-8"
vim.opt.signcolumn = "yes"
vim.opt.clipboard:append { 'unnamedplus' }
vim.opt.guicursor = {
  'i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
  'n-v-c:block-Cursor',
  'r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100'
}
vim.opt.cmdheight = 0
vim.opt.cmdwinheight = 1
vim.opt.winblend = 0
vim.opt.pumblend = 15

vim.opt.fillchars:append({ eob = " " })

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

-- cmdline window setting
vim.keymap.set("n", ":", ":<C-f>", { silent = true, noremap = true })
vim.keymap.set("n", "/", "/<C-f>", { silent = true, noremap = true })
vim.keymap.set("n", "?", "?<C-f>", { silent = true, noremap = true })

vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = { "*" },
  callback = function()
    vim.wo.number = false
    vim.wo.signcolumn = "no"
    vim.wo.statuscolumn = ""
    vim.cmd("startinsert")
    vim.keymap.set("n", "q", "<Cmd>quit<CR>", { buffer = true, silent = true })
    vim.keymap.set("i", "<C-c>", "<Esc><Cmd>quit<CR>", { buffer = true, silent = true })
    vim.keymap.set("i", "<Esc>", "<Esc><Cmd>quit<CR>", { buffer = true, silent = true })
  end
})

vim.opt.verbosefile = "/tmp/nvim/verbose"
vim.opt.swapfile = false
