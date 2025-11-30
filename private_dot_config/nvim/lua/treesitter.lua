-- change default branch from master to main. this is old settings
-- require("nvim-treesitter.configs").setup({
--   ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
--   sync_install = false,
--   auto_install = true,
--   ignore_install = { "javascript" },
--   indent = {
--     enable = true
--   },
--   highlight = {
--     enable = true,
--     -- disable = { "c", "rust" },
--     disable = function(lang, buf)
--       local max_filesize = 100 * 1024 -- 100 KB
--       local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--       if ok and stats and stats.size > max_filesize then
--         return true
--       end
--     end,
--     additional_vim_regex_highlighting = false,
--   },
-- })

-- main branch settings(https://github.com/nvim-treesitter/nvim-treesitter/tree/main)
require("nvim-treesitter").install({ "bash", "fish", "comment", "lua", "vim", "markdown", "markdown_inline", "vimdoc" })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "bash", "fish", "comment", "lua", "vim", "markdown", "markdown_inline", "vimdoc" },
  callback = function()
    vim.treesitter.start()
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
