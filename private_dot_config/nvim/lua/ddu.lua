-- ddu config
vim.fn["ddu#custom#patch_global"]({
  ui = "ff",
  uiParams = {
    ff = {
      startAutoAction = true,
      autoAction = {
        delay = 0,
        name = "preview",
      },
      split = "floating",
      autoResize = true,
      floatingBorder = "rounded",
      winHeight = "&lines - 8",
      winWidth = "&columns / 2 - 2",
      winRow = 1,
      winCol = 1,
      previewFloating = true,
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewHeight = "&lines - 8",
      previewWidth = "&columns / 2 - 2",
      previewRow = 1,
      previewCol = "&columns / 2 + 1",
    },
  },
  sources = { "file" },
  sourceOptions = {
    _ = {
      matcher = { "matcher_substring" },
      columns = { "icon_filename" },
      sorters = { "sorter_alpha" },
      volatile = true,
    },
    help = {
      defaultAction = "open",
    },
    file_rec = {
      path = "/home/riou/",
    },
  },
  kindOptions = {
    file = {
      defaultAction = "open",
    },
  },
  columnParams = {
    icon_filename = {
      defaultIcon = { icon = "" },
    },
  },
});
vim.fn["ddu#custom#patch_local"]("help-ff", {
  sources = { "help" },
  sourceParams = {
    helplang = "ja",
    style = "minimal",
  },
});
vim.fn["ddu#custom#patch_local"]("buffer", {
  ui = "filer",
  sources = { name = "buffer" },
});
vim.fn["ddu#custom#patch_local"]("filer", {
  ui = "filer",
  uiParams = {
    filer = {
      split = "floating",
      floatingBorder = "rounded",
      previewFloating = true,
      previewSplit = "vertical",
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
    },
  },
  sources = { "file" },
  sourceOptions = {
    _ = {
      columns = "icon_filename",
      sorters = "sorter_alpha",
    },
  },
  kindOptions = {
    file = {
      defaultAction = "open",
    },
  },
  actionOptions = {
    narrow = "quit",
  },
});
local keymap = vim.keymap.set
local ddu_do_action = vim.fn["ddu#ui#do_action"]

local function ddu_ff_keymaps()
	keymap("n", "<CR>", function()
		ddu_do_action("itemAction")
	end, { buffer = true })
	keymap("n", "i", function()
		ddu_do_action("openFilterWindow")
	end, { buffer = true })
	keymap("n", "q", function()
		ddu_do_action("quit")
	end, { buffer = true })
  keymap("n", "<Right>", function()
    ddu_do_action("expandItem", { mode = "toggle" })
  end, { buffer = true })
end

local function ddu_ff_filter_keymaps()
	keymap("i", "<CR>", function()
		vim.cmd.stopinsert()
		ddu_do_action("closeFilterWindow")
	end, { buffer = true })
	keymap("n", "<CR>", function()
		ddu_do_action("cloeFilterWindow")
	end, { buffer = true })
end

local function ddu_filer_keymaps()
	keymap("n", "<CR>", function()
		ddu_do_action("itemAction")
	end, { buffer = true })
	keymap("n", "<Space>", function()
		ddu_do_action("toggleSelectItem")
	end, { buffer = true })
	keymap("n", "<Right>", function()
		ddu_do_action("expandItem", { mode = "toggle" })
	end, { buffer = true })
	keymap("n", "q", function()
		ddu_do_action("quit")
	end, { buffer = true })
  keymap("n", "<Tab>", function ()
    ddu_do_action("togglePreview")
  end, { buffer = true })
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ddu-ff",
	callback = ddu_ff_keymaps,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ddu-filer",
	callback = ddu_filer_keymaps,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ddu-ff-filter",
	callback = ddu_ff_filter_keymaps,
})

-- vim.api.nvim_create_user_command("Help", function()
-- 	vim.fn["ddu#start"]({ name = "help-ff" })
-- end, {})

vim.api.nvim_create_user_command("Fi", function()
	vim.fn["ddu#start"]({ name = "filer" })
end, {})

vim.api.nvim_create_user_command("Ff", function()
	vim.fn["ddu#start"]()
end, {})

vim.api.nvim_create_user_command("Bf", function()
	vim.fn["ddu#start"]({ name = "buffer" })
end, {})
