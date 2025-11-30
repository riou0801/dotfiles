vim.keymap.set("i",
  "<C-l>", "<Plug>(denippet-expand)", { noremap = true }
);
vim.keymap.set("i", "<Tab>", "<Plug>(denippet-expand-or-jump)", { noremap = true }
);
vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if vim.fn["denippet#jumpable"](1) then
      return "<Plug>(denippet-jump-next)"
    else
      return "<Tab>"
    end
  end,
  { expr = true, noremap = true });
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if vim.fn["denippet#jumpable"](-1) then
      return "<Plug>(denippet-jump-prev)"
    else
      return "<S-Tab>"
    end
  end,
  { expr = true, noremap = true })
