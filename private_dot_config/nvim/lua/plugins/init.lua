-- port dvpm to built-in package manager
-- TODO: need functional or dependencies sort. ex. ui,utis,lsp,ddc etc.
-- INFO: if there are dependent plugin, they adds before main, such as nvim-cmp-kit -> nvim-ix.

vim.pack.add({
  "https://github.com/vim-jp/vimdoc-ja",
  "https://github.com/vim-denops/denops.vim",
  "https://github.com/vim-denops/denops-shared-server.vim",
  "https://github.com/catppuccin/nvim",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main"
  },
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/lambdalisue/vim-fall",
  "https://github.com/hrsh7th/nvim-cmp-kit",
  "https://github.com/hrsh7th/nvim-deck",
  "https://github.com/hrsh7th/nvim-ix",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/rcarriga/nvim-notify",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/mvllow/modes.nvim",
})
vim.pack.add({
  "https://github.com/luukvbaal/statuscol.nvim",
  "https://github.com/caliguIa/zendiagram.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
});
vim.pack.add({
  "https://github.com/yukimemi/chronicle.vim",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/higashi000/dps-kakkonan",
  "https://github.com/hrsh7th/nvim-insx",
  "https://github.com/uga-rosa/ccc.nvim",
  "https://github.com/uga-rosa/denippet.vim",
  "https://github.com/ryoppippi/denippet-autoimport-vscode",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/ionide/ionide-vim",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
});
-- ddc settings
vim.pack.add({
  "https://github.com/Shougo/pum.vim",
  "https://github.com/matsui54/denops-signature_help",
  "https://github.com/uga-rosa/ddc-source-lsp-setup",
  "https://github.com/Shougo/ddc-ui-none",
  "https://github.com/Shougo/ddc-ui-native",
  "https://github.com/Shougo/ddc-ui-inline",
  "https://github.com/Shougo/ddc-ui-pum",
  "https://github.com/LumaKernel/ddc-source-file",
  "https://github.com/Shougo/ddc-source-line",
  "https://github.com/Shougo/ddc-source-around",
  "https://github.com/Shougo/ddc-source-input",
  "https://github.com/Shougo/ddc-source-lsp",
  "https://github.com/Shougo/ddc-source-cmdline",
  "https://github.com/Shougo/ddc-source-cmdline-history",
  "https://github.com/Shougo/ddc-source-vim",
  "https://github.com/Shougo/ddc-source-shell-native",
  "https://github.com/uga-rosa/ddc-source-nvim-lua",
  "https://github.com/tani/ddc-fuzzy",
  "https://github.com/Shougo/ddc-filter-matcher_head",
  "https://github.com/Shougo/ddc-filter-sorter_rank",
  "https://github.com/Shougo/ddc-filter-matcher_length",
  "https://github.com/Shougo/ddc-filter-converter_truncate_abbr",
  "https://github.com/Shougo/ddc-filter-sorter_lsp_kind",
  "https://github.com/Shougo/ddc-filter-converter_kind_labels",
  "https://github.com/matsui54/ddc-postfilter_score",
  "https://github.com/Shougo/ddc.vim",
});
--  ddu settings
vim.pack.add({
  "https://github.com/Shougo/ddu-ui-ff",
  "https://github.com/Shougo/ddu-ui-filer",
  "https://github.com/Shougo/ddu-source-file",
  "https://github.com/Shougo/ddu-kind-file",
  "https://github.com/Shougo/ddu-source-file_rec",
  "https://github.com/Shougo/ddu-filter-matcher_substring",
  "https://github.com/Shougo/ddu-filter-sorter_alpha",
  "https://github.com/matsui54/ddu-source-help",
  "https://github.com/shun/ddu-source-buffer",
  "https://github.com/ryota2357/ddu-column-icon_filename",
  "https://github.com/Shougo/ddu.vim",
});

-- autocmd and global variables section
vim.api.nvim_create_user_command("DenoCache", function()
  return vim.fn["denops#cache#update"]({ reload = true })
end, {})
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function()
    vim.cmd([[TSUpdate]])
    vim.cmd([[DenoCache]])
  end
})

vim.g.denops_server_addr = "127.0.0.1:32123"
vim.g.timeoutlen = 100
vim.g.chronicle_debug = false
vim.g.chronicle_ignore_filetype = { "help", "log", "gitcommit" }
vim.g.chronicle_echo = false
vim.g.chronicle_notify = false
vim.g.chronicle_read_path = "/home/riou/.cache/chronicle/read"
vim.g.chronicle_write_path = "/home/riou/.cache/chronicle/write"


-- another config file or M.setup() section
require("treesitter")
require("nvim-quicker")
require("nvim-deck")
require("nvim-lualine")
-- require("nvim-notify")
require("kakkonan")
require("nvim-ccc")
require("lsp")
require("ddc")
require("ddu")
require("nvim-catppuccin")


require("statuscol").setup()
require("which-key").setup()
require("zendiagram").setup()
require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
  code = { width = "block" }
})
require("chronicle-fzf").setup()
require("ibl").setup({ indent = { char = "▏" } })
require("Comment").setup()
require("insx.preset.standard").setup()
-- require("lazydev").setup()
require('tiny-inline-diagnostic').setup({
  preset = "simple",
  options = {
    show_source = {
      enabled = true
    }
  }
})
-- require("modes").setup()
