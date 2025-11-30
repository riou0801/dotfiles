-- 便利ヘルパ（<CR> などの特殊キーを安全に返す）

-- === Insert mode ===
vim.keymap.set("i", "<C-n>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#select_relative"](1)
  else
    return "<C-n>"
  end
end, { noremap = true })

vim.keymap.set("i", "<C-p>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#select_relative"](-1)
  else
    return "<C-p>"
  end
end, { noremap = true })

vim.keymap.set("i", "<CR>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#confirm"]()
  else
    return "<CR>"
  end
end, { noremap = true })

vim.keymap.set("i", "<C-y>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#confirm"]()
  else
    return "<C-y>"
  end
end, { noremap = true })

-- （必要なら）suffix 確定
vim.keymap.set("i", "<C-l>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#confirm_suffix"]()
  else
    return "<C-l>"
  end
end, { noremap = true })

-- === Command-line mode ===
vim.keymap.set("c", "<C-n>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#insert_relative"](1)
  else
    return "<Down>"
  end
end, { silent = true, noremap = true })

vim.keymap.set("c", "<C-p>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#insert_relative"](-1)
  else
    return "<Up>"
  end
end, { silent = true, noremap = true })

vim.keymap.set("c", "<CR>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#confirm"]()
  else
    return "<C-j>"
  end
end, { silent = true, noremap = true })

vim.keymap.set("c", "<C-y>", function()
  if vim.fn["pum#visible"]() then
    return vim.fn["pum#map#confirm"]()
  else
    return "<C-y>"
  end
end, { silent = true, noremap = true })
