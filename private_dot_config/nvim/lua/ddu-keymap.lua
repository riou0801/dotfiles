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
