-- おまじない
vim.loader.enable()

-- vim.opt.runtimepath:append(vim.fn.expand("~/.config/nvim/cache"))
-- vim.cmd.source[[~/.config/nvim/cache/dvpm_plugin_cache.vim]]
--
-- local denops = vim.fn.expand("~/.cache/nvim/dvpm/github.com/vim-denops/denops.vim")
-- if not vim.uv.fs_stat(denops) then
--   vim.fn.system({ "git", "clone", "https://github.com/vim-denops/denops.vim", denops })
-- end
--
-- vim.opt.runtimepath:prepend(denops)
vim.opt.runtimepath:prepend(vim.fn.expand("~/.config/nvim/snippets"))
require("plugins")
require("filetype")
-- require("snippet")
require("options")


--
vim.api.nvim_create_user_command(
  "Mes",
  "new Message | put =execute('message') | set buftype=nofile",
  { desc = "messages to buffer" }
)

vim.api.nvim_create_user_command(
  "Config",
  function()
    vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
  end,
  { desc = "open init.lua" }
)
vim.api.nvim_create_user_command(
  "DvpmConfig",
  function()
    vim.cmd.edit(vim.fn.stdpath("config") .. "/denops/config/main.ts")
  end,
  { desc = "open dvpm config" }
)

vim.api.nvim_create_user_command("PackUp",
  function()
    return vim.pack.update()
  end, { desc = "Update package" }
)
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" },
  {
    pattern = "*",
    command = "call system('fcitx5-remote -c') | echo 'IME off'"
  }
)


vim.keymap.set(
  "n",
  "<Space>ff",
  "<Cmd>FzfLua files<CR>",
  { desc = "FzfLua for files" }
)

vim.keymap.set(
  "n",
  "<Space>fb",
  "<Cmd>FzfLua buffers<CR>",
  {desc = "FzfLua for buffers"}
)
require("vim._extui").enable({
  enable = true,
  msg = {
    target = "cmd",
    timeout = 4000,
  },
})
