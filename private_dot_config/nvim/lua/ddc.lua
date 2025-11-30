-- ddc config
vim.fn["pum#set_option"]({
  border = "single",
  max_height = 40,
  max_width = 56,
  preview = true,
  preview_border = "single",
  preview_width = 72,
  scrollbar_char = "",
  offset_cmdcol = ".",
});

-- vim.fn["ddc#custom#patch_filetype"]("lua", {
--   sources = { "lsp", "denippet", "around", "nvim-lua" },
-- });

vim.fn["ddc#custom#patch_filetype"]("vim", {
  sources = { "lsp", "denippet", "around", "vim" },
  specialBufferCompletion = true,
});

vim.fn["ddc#custom#patch_global"]({
  ui = "pum",
  uiParams = {
    pum = {
      insert = false
    }
  },
  -- dynamicUi = function()
  --   local m = vim.api.nvim_get_mode().mode
  --   if m == "i" then
  --     return "native"
  --   elseif m ~= "i" then
  --     return "pum"
  --   end
  -- end,
  --   if vim.api.nvim_get_mode().mode == "i" then
  --     vim.notify("insert")
  --     return "none"
  --   else
  --     vim.notify("not insert")
  --     return "pum"
  --   end
  -- end,
  autoCompleteEvents = {
    "InsertEnter",
    "TextChangedI",
    "TextChangedP",
    "TextChangedT",
    "CmdlineChanged",
    "CmdlineEnter",
  },
  sources = { "lsp", "denippet", "around" },
  cmdlineSources = {
    [":"] = {
      "cmdline",
      "cmdline_history",
      "shell_native",
      "file",
      "around",
    },
    ["@"] = { "input", "cmdline_history", "file", "around" },
    [">"] = { "input", "cmdline_history", "file", "around" },
    ["/"] = { "around" },
    ["?"] = { "around" },
    ["-"] = { "around" },
    ["="] = { "input" },
  },
  sourceOptions = {
    _ = {
      minAutoCompleteLength = 2,
      ignoreCase = true,
      isVolatile = true,
      maxItems = 10,
      matchers = { "matcher_fuzzy" },
      sorters = { "sorter_fuzzy", "sorter_rank" },
      converters = { "converter_fuzzy", "converter_truncate_abbr" },
    },
    input = {
      mark = "input",
      isVolatile = true,
    },
    line = { mark = "line" },
    cmdline = {
      mark = "cmd",
      forceCompletionPattern = "\\.\\w*|::\\w*|->\\w*",
    },
    denippet = { mark = "denippet" },
    cmdline_history = { mark = "c-his" },
    shell_native = { mark = "fish" },
    around = { mark = "around" },
    vim = {
      mark = "vim",
      isVolatile = true,
    },
    ["nvim-lua"] = {
      mark = "lua",
      forceCompletionPattern = "\\.\\w*",
    },
    lsp = {
      mark = "lsp",
      forceCompletionPattern = "\\.\\w*|::\\w*|->\\w*",
      dup = "force",
      sorters = { "sorter_lsp-kind" },
      converters = { "converter_kind_labels" },
    },
  },
  sourceParams = {
    line = { maxSize = 250 },
    shell_native = { shell = "fish" },
    lsp = {
      snippetEngine = vim.fn["denops#callback#register"](function(body)
        vim.fn["denippet#anonymous"](body)
      end),
      enableResolveItem = true,
      enableAdditionalTextEdit = true,
    },
  },
  postFilters = { "postfilter_score" },
  filterParams = {
    ["sorter_lsp_kind"] = {
      priority = {
        "Enum",
        "Method",
        "Function",
        "Field",
        "Variable",
      },
    },
    ["converter_kind_labels"] = {
      kindLabels = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = '',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
      },
      kindHlGroups = {
        Method = 'Function',
        Function = 'Function',
        Constructor = 'Function',
        Field = 'Identifier',
        Variable = 'Identifier',
        Class = 'Structure',
        Interface = 'Structure',
      },
    },
    ["postfilter_score"] = {
      showScore = true,
    },
    ["converter_truncate_abbr"] = {
      maxAbbrWidth = 60,
    },
  },
});

require("ddc_source_lsp_setup").setup({
  override_capabilities = true,
  respect_trigger = true
})

-- keymap section
vim.keymap.set({ "i" }, "<Down>",
  function()
    if vim.fn["pum#visible"]() then
      return "<Cmd>call pum#map#insert_relative(1, 'loop')<CR>"
    else
      return "<Down>"
    end
  end,
  { expr = true, silent = true, noremap = true }
);
vim.keymap.set({ "c" }, "<Down>",
  function()
    if vim.fn["pum#visible"]() then
      return "<Cmd>call pum#map#insert_relative(1, 'loop')<CR>"
    else
      return "<C-U><Down>"
    end
  end,
  { expr = true, silent = true, noremap = true }
);

vim.keymap.set({ "i", "c" }, "<Tab>",
  function()
    if vim.fn["pum#visible"]() then
      return "<Cmd>call pum#map#insert_relative(1, 'loop')<CR>"
    elseif vim.fn["pumvisible"]() then
      return "<C-n>"
    else
      return "<Tab>"
    end
  end,
  { expr = true, silent = true, noremap = true }
);

vim.keymap.set({ "i" }, "<Up>",
  function()
    if vim.fn["pum#visible"]() then
      return "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>"
    else
      return "<Up>"
    end
  end,
  { expr = true, silent = true, noremap = true }
);
vim.keymap.set({ "c" }, "<Up>",
  function()
    if vim.fn["pum#visible"]() then
      return "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>"
    else
      return "<C-U><Up>"
    end
  end,
  { expr = true, silent = true, noremap = true }
);

vim.keymap.set({ "i", "c" }, "<S-Tab>",
  function()
    if vim.fn["pum#visible"]() then
      return "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>"
    else
      return "<S-Tab>"
    end
  end, { expr = true, silent = true, noremap = true }
);

-- error error error...
vim.keymap.set({ "i" }, "<CR>",
  function()
    return vim.fn["pum#visible"]() and "<Cmd>call pum#map#confirm()<CR>"
        or [[<Cmd>call luaeval("require('insx.kit.Vim.keymap').send(require('insx').expand('<LT>CR>'))"<CR>)]]
  end,
  { expr = true, silent = true }
);

vim.keymap.set({ "i", "c" }, "<Esc>",
  function()
    if vim.fn["pum#visible"]() then
      return "<Cmd>call pum#map#cancel()<CR><Esc>"
    else
      return "<Esc>"
    end
  end,
  { expr = true, silent = true, noremap = true }
);

vim.keymap.set({ "i", "c" }, "<C-j>",
  function()
    if vim.fn["pum#visible"]() then
      return vim.fn["pum#map#select_relative"](1, 'loop')
    else
      return "<C-j>"
    end
  end,
  { expr = true }
);
vim.keymap.set({ "i", "c" }, "<C-k>",
  function()
    if vim.fn["pum#visible"]() then
      return vim.fn["pum#map#select_relative"](-1, 'loop')
    else
      return "<C-k>"
    end
  end,
  { expr = true }
);

vim.keymap.set({ "i", "c" }, "<C-l>",
  function()
    return vim.fn["pum#map#confirm_suffix"]()
  end,
  { silent = true }
);
vim.keymap.set({ "i", "c" }, "<C-y>",
  function()
    return vim.fn["pum#map#confirm"]()
  end,
  { silent = true }
);


-- denops_signature
-- use builtin signature in Lsp(./lsp/init.lua)
-- vim.fn["signature_help#enable"]();
-- vim.g.signature_help_config = {
--   contentsStyle = "full",
--   viewStyle = "floating",
-- }

-- vim.keymap.set("i", "<C-Up>",
--   function()
--     return vim.fn["signature_help#scroll"](-4)
--   end,
--   { expr = true, buffer = true, desc = "signature scroll(-4)" }
-- )
-- vim.keymap.set("i", "<C-Down>",
--   function()
--     return vim.fn["signature_help#scroll"](4)
--   end,
--   { expr = true, buffer = true, desc = "signature scroll(+4)" }
-- )

vim.fn["ddc#enable"]();
vim.fn["ddc#enable_cmdline_completion"]();

vim.api.nvim_create_autocmd({ "CmdlineLeavePre", "User" }, {
  pattern = { "*", "DDCCmdlineLeave" },
  callback = function()
    return vim.fn["ddc#enable_cmdline_completion"]()
  end,
  once = true
});

-- ddc with cmdlinewindow
vim.api.nvim_create_autocmd({ "CmdwinEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.fn["ddc#custom#patch_buffer"]("sources", {
      "vim",
      "nvim-lua",
      "cmdline",
      "cmdline_history",
      "shell_native",
      "file",
      "around",
    })
  end
})
