import * as fn from "jsr:@denops/std/function";
import * as mapping from "jsr:@denops/std/mapping";
import type { Denops } from "jsr:@denops/std";
import { ensure, is } from "jsr:@core/unknownutil";
import { execute } from "jsr:@denops/std/helper";
// import { options } from "jsr:@denops/std/variable/options";
import { Dvpm } from "jsr:@yukimemi/dvpm";
import * as vars from "jsr:@denops/std/variable";
import * as autocmd from "jsr:@denops/std/autocmd";
import * as nFunc from "jsr:@denops/std/function/nvim/";

export async function main(denops: Denops): Promise<void> {
  // プラグインをインストールするベースとなるパスです。
  const base_path = (await fn.has(denops, "nvim")) ? "~/.cache/nvim/dvpm" : "~/.cache/vim/dvpm";
  const base = ensure(await fn.expand(denops, base_path), is.String);
  const cache_path = (await fn.has(denops, "nvim"))
    ? "~/.config/nvim/cache/dvpm_plugin_cache.vim"
    : "~/.config/vim/cache/dvpm_plugin_cache.vim";
  // This cache path must be pre-appended to the runtimepath.
  // Add it in vimrc or init.lua by yourself, or specify the path originally added to
  // runtimepath of Vim / Neovim.
  const cache = ensure(await fn.expand(denops, cache_path), is.String);
  //
  // ベースパスを引数に、 Dvpm.begin を実行して、 `dvpm` インスタンスを取得します。
  const dvpm = await Dvpm.begin(denops, { base, cache, debug: true });

  // 以降は `dvpm.add` を用いて必要なプラグインを追加していきます。
  await dvpm.add({
    url: "vim-denops/denops.vim",
    dst: "~/.cache/nvim/dvpm/github.com/vim-denops/denops.vim",
  });
  await dvpm.add({ url: "vim-jp/vimdoc-ja" });
  await dvpm.add({
    url: "vim-denops/denops-shared-server.vim",
    before: async ({ denops }) => {
      await vars.globals.set(denops, "denops_server_addr", "127.0.0.1:32123");
    },
  });
  // ui & utils
  await dvpm.add({
    url: "catppuccin/nvim",
    cache: { afterFile: "~/.config/nvim/lua/nvim-catppuccin.lua" },
  });
  await dvpm.add({
    url: "nvim-treesitter/nvim-treesitter",
    build: async ({ denops, info }) => {
      if (info.isLoad) {
        await denops.cmd("TSUpdate");
      }
    },
    afterFile: "~/.config/nvim/lua/treesitter.lua",
  });
  await dvpm.add({
    url: "stevearc/quicker.nvim",
    afterFile: "~/.config/nvim/lua/nvim-quicker.lua",
  });
  await dvpm.add({ url: "nvim-tree/nvim-web-devicons" });
  await dvpm.add({
    url: "goolord/alpha-nvim",
    dependencies: ["nvim-tree/nvim-web-devicons"],
    enabled: false,
    after: async ({ denops }) => {
      await denops.call(
        "luaeval",
        "require[[alpha]].setup(require[[alpha.themes.dashboard]].config)",
      );
    },
  });
  await dvpm.add({
    url: "folke/which-key.nvim",
    after: async ({ denops }) => {
      await vars.globals.set(denops, "timeoutlen", "100"),
        await denops.call("luaeval", `require("which-key").setup()`);
    },
  });
  // from noice to cmdline.vim
  await dvpm.add({
    url: "Shougo/cmdline.vim",
    enabled: false,
    after: async ({ denops }) => {
      await denops.call("cmdline#set_option", {
        blend: "0",
        border: "rounded",
      });
      // await mapping.map(
      //   denops,
      //   ":",
      //   "<Cmd>call cmdline#input()<CR>:",
      //   { mode: "n", noremap: true })
    },
  });
  await dvpm.add({
    url: "lambdalisue/vim-fall",
    enabled: true,
  });
  await dvpm.add({
    url: "hrsh7th/nvim-deck",
    afterFile: "~/.config/nvim/lua/nvim-deck.lua",
    enabled: true,
  });
  await dvpm.add({
    url: "ibhagwan/fzf-lua",
    afterFile: "~/.config/nvim/lua/fzfcommands.lua",
  });
  await dvpm.add({
    url: "rcarriga/nvim-notify",
    afterFile: "~/.config/nvim/lua/nvim-notify.lua",
  });
  await dvpm.add({
    url: "nvim-lualine/lualine.nvim",
    dependencies: ["catppuccin/nvim"],
    afterFile: "~/.config/nvim/lua/nvim-lualine.lua",
  });
  await dvpm.add({
    url: "luukvbaal/statuscol.nvim",
    after: async ({ denops }) => {
      await denops.call("luaeval", `require("statuscol").setup()`);
    },
  });
  await dvpm.add({
    url: "caliguIa/zendiagram.nvim",
    after: async ({ denops }) => {
      await denops.call("luaeval", `require("zendiagram").setup()`);
    },
  });
  await dvpm.add({
    url: "MeanderingProgrammer/render-markdown.nvim",
    after: async ({ denops }) => {
      await denops.call("luaeval", `require("render-markdown").setup()`);
    },
  });
  await dvpm.add({
    url: "rolv-apneseth/tfm.nvim",
    enabled: false,
    after: async ({ denops }) => {
      await execute(
        denops,
        `lua << EOF
        vim.api.nvim_set_keymap("n", "<leader>e", "", {
          noremap = true,
          callback = require("tfm").open,
        })
        EOF
        `,
      );
    },
  });
  await dvpm.add({
    url: "yukimemi/chronicle.vim",
    before: async ({ denops }) => {
      await vars.globals.set(denops, "chronicle_debug", false);
      await vars.globals.set(denops, "chronicle_echo", false);
      await vars.globals.set(denops, "chronicle_notify", false);
      await vars.globals.set(
        denops,
        "chronicle_read_path",
        "/home/riou/.cache/chronicle/read",
      );
      await vars.globals.set(
        denops,
        "chronicle_write_path",
        "/home/riou/.cache/chronicle/write",
      );
    },
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("chronicle-fzf").setup()');
    },
  });
  await dvpm.add({ url: "rafamadriz/friendly-snippets" });
  await dvpm.add({
    url: "numToStr/Comment.nvim",
    enabled: true,
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("Comment").setup()');
    },
  });
  await dvpm.add({
    url: "lukas-reineke/indent-blankline.nvim",
    after: async ({ denops }) => {
      await denops.call(
        "luaeval",
        'require("ibl").setup({ indent = { char = "▏" } })',
      );
    },
  });
  await dvpm.add({
    url: "m4xshen/autoclose.nvim",
    enabled: false,
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("autoclose").setup()');
    },
  });
  await dvpm.add({
    url: "higashi000/dps-kakkonan",
    enabled: true,
    afterFile: "~/.config/nvim/lua/kakkonan.lua",
  });
  await dvpm.add({
    url: "hrsh7th/nvim-insx",
    enabled: true,
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("insx.preset.standard").setup()');
    },
  });
  await dvpm.add({
    url: "uga-rosa/ccc.nvim",
    afterFile: "~/.config/nvim/lua/nvim-ccc.lua",
  });
  await dvpm.add({
    url: "uga-rosa/denippet.vim",
    after: async ({ denops }) => {
      await mapping.map(
        denops,
        "<C-l>",
        "<Plug>(denippet-expand)",
        { mode: "i", noremap: true },
      );
      await mapping.map(
        denops,
        "<expr><Tab>",
        "<Plug>(denippet-expand-or-jump)",
        { mode: "i", noremap: true },
      );
      await mapping.map(
        denops,
        "<expr><Tab>",
        "denippet#jumpable() ? '<Plug>(denippet-jump-next)' : '<Tab>'",
        { mode: ["i", "s"], noremap: true },
      );
      await mapping.map(
        denops,
        "<expr><S-Tab>",
        "denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-Tab>'",
        { mode: ["i", "s"], noremap: true },
      );
    },
  });
  await dvpm.add({
    url: "ryoppippi/denippet-autoimport-vscode",
    enabled: true,
    dependencies: ["uga-rosa/denippet.vim"],
  });
  await dvpm.add({
    url: "neovim/nvim-lspconfig",
    enabled: true,
    afterFile: "~/.config/nvim/lsp/init.lua",
  });
  await dvpm.add({
    url: "folke/lazydev.nvim",
    dependencies: ["neovim/nvim-lspconfig"],
    enabled: true,
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("lazydev").setup()');
    },
  });
  await dvpm.add({
    url: "ionide/ionide-vim",
    dependencies: ["neovim/nvim-lspconfig"],
  });
  await dvpm.add({
    url: "sigmaSd/deno-nvim",
    dependencies: ["neovim/nvim-lspconfig"],
    enabled: false,
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("deno-nvim").setup()');
    },
  });
  await dvpm.add({
    url: "rachartier/tiny-inline-diagnostic.nvim",
    dependencies: ["neovim/nvim-lspconfig"],
    enabled: true,
    after: async ({ denops }) => {
      await denops.call("luaeval", "require('tiny-inline-diagnostic').setup()");
    },
  });

  // ddc settings
  await dvpm.add({
    url: "Shougo/pum.vim",
    after: async ({ denops }) => {
      await denops.call("pum#set_option", {
        border: "none",
        max_height: 40,
        max_width: 56,
        preview: true,
        preview_border: "none",
        preview_width: 56,
        scrollbar_char: "",
        offset_cmdcol: ".",
      });
    },
  });
  await dvpm.add({
    url: "matsui54/denops-signature_help",
    after: async ({ denops }) => {
      await vars.globals.set(denops, "signature_help_config", {
        contentsStyle: "full",
        viewStyle: "floating",
      });
      await denops.call("signature_help#enable");
    },
  });
  await dvpm.add({
    url: "uga-rosa/ddc-source-lsp-setup",
    dependencies: ["Shougo/ddc-source-lsp"],
    after: async ({ denops }) => {
      await denops.call("luaeval", `require("ddc_source_lsp_setup").setup({})`);
    },
  });

  await dvpm.add({ url: "Shougo/ddc-ui-native" });
  await dvpm.add({ url: "Shougo/ddc-ui-pum" });
  await dvpm.add({ url: "LumaKernel/ddc-source-file" });
  await dvpm.add({ url: "Shougo/ddc-source-line" });
  await dvpm.add({ url: "Shougo/ddc-source-around" });
  await dvpm.add({ url: "Shougo/ddc-source-input" });
  await dvpm.add({ url: "Shougo/ddc-source-lsp" });
  await dvpm.add({ url: "Shougo/ddc-source-cmdline" });
  await dvpm.add({ url: "Shougo/ddc-source-cmdline-history" });
  await dvpm.add({ url: "Shougo/ddc-source-vim" });
  await dvpm.add({ url: "Shougo/ddc-source-shell-native" });
  await dvpm.add({ url: "uga-rosa/ddc-source-nvim-lua" });
  // { url: "kyoh86/ddc-source-ollama" },
  await dvpm.add({ url: "tani/ddc-fuzzy" });
  await dvpm.add({ url: "Shougo/ddc-filter-matcher_head" });
  await dvpm.add({ url: "Shougo/ddc-filter-sorter_rank" });
  await dvpm.add({ url: "Shougo/ddc-filter-matcher_length" });
  await dvpm.add({ url: "Shougo/ddc-filter-converter_truncate_abbr" });
  await dvpm.add({ url: "matsui54/ddc-postfilter_score" });
  await dvpm.add({
    url: "Shougo/ddc.vim",
    dependencies: [
      "Shougo/ddc-ui-native",
      "Shougo/ddc-ui-pum",
      "LumaKernel/ddc-source-file",
      "Shougo/ddc-source-line",
      "Shougo/ddc-source-around",
      "Shougo/ddc-source-input",
      "Shougo/ddc-source-lsp",
      "Shougo/ddc-source-cmdline",
      "Shougo/ddc-source-cmdline-history",
      "Shougo/ddc-source-vim",
      "Shougo/ddc-source-shell-native",
      "uga-rosa/ddc-source-nvim-lua",
      "uga-rosa/ddc-source-lsp-setup",
      "uga-rosa/denippet.vim",
      "tani/ddc-fuzzy",
      "Shougo/ddc-filter-matcher_head",
      "Shougo/ddc-filter-sorter_rank",
      "Shougo/ddc-filter-matcher_length",
      "Shougo/ddc-filter-converter_truncate_abbr",
      "matsui54/ddc-postfilter_score",
      "matsui54/denops-signature_help",
    ],
    after: async ({ denops }) => {
      const defaultSources = ["lsp", "denippet", "around"];
      // const snippetEngine = await denops.call(
      //   "denops#callback#register",
      //   async (body: string) => {
      //     await denops.call("denippet#anonymous", body);
      //   },
      // );
      await denops.call("ddc#custom#patch_filetype", "lua", {
        sources: [...defaultSources, "nvim-lua"],
      });
      await denops.call("ddc#custom#patch_filetype", "vim", {
        sources: [...defaultSources, "vim"],
        specialBufferCompletion: true,
      });
      await denops.call("ddc#custom#patch_global", {
        ui: "pum",
        autoCompleteEvents: [
          "InsertEnter",
          "TextChangedI",
          "TextChangedP",
          "TextChangedT",
          "CmdlineChanged",
          "CmdlineEnter",
        ],
        sources: defaultSources,
        cmdlineSources: {
          ":": [
            "cmdline",
            "cmdline_history",
            "shell_native",
            "file",
            "around",
          ],
          "@": ["input", "cmdline_history", "file", "around"],
          ">": ["input", "cmdline_history", "file", "around"],
          "/": ["around"],
          "?": ["around"],
          "-": ["around"],
          "=": ["input"],
        },
        sourceOptions: {
          _: {
            minAutoCompleteLength: 2,
            ignoreCase: true,
            isVolatile: true,
            maxItems: 5,
            matchers: ["matcher_fuzzy"],
            sorters: ["sorter_fuzzy", "sorter_rank"],
            converters: ["converter_fuzzy", "converter_truncate_abbr"],
          },
          input: {
            mark: "input",
            isVolatile: true,
          },
          line: { mark: "line" },
          cmdline: {
            mark: "cmd",
            forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          },
          denippet: { mark: "denippet" },
          "cmdline_history": { mark: "c-his" },
          "shell_native": { mark: "fish" },
          around: { mark: "around" },
          vim: {
            mark: "vim",
            isVolatile: true,
          },
          "nvim-lua": {
            mark: "lua",
            forceCompletionPattern: "\\.\\w*",
          },
          lsp: {
            mark: "lsp",
            forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
            dup: "force",
            sorters: ["sorter_lsp-kind"],
          },
          ollama: {
            matchers: [],
            mark: "ollama",
            minAutoCompleteLength: 0,
          },
        },
        sourceParams: {
          line: { maxSize: 250 },
          "shell_native": { shell: "fish" },
          lsp: {
            enableResolveItem: true,
            enableAdditionalTextEdit: true,
          },
        },
        postFilters: ["postfilter_score"],
        filterParams: {
          "sorter_lsp-kind": {
            priority: [
              "Enum",
              ["Method", "Function"],
              "Field",
              "Variable",
            ],
          },
          postfilter_score: {
            showScore: true,
          },
          converter_truncate_abbr: {
            maxAbbrWidth: 60,
          },
        },
      });
      await mapping.map(
        denops,
        "<expr><Down>",
        "pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Down>'",
        { mode: ["i", "c"], noremap: true },
      );
      await mapping.map(
        denops,
        "<expr><Tab>",
        "pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Tab>'",
        { mode: ["i", "c"], noremap: true },
      );
      await mapping.map(
        denops,
        "<expr><Up>",
        "pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Up>'",
        { mode: ["i", "c"], noremap: true },
      ),
        await mapping.map(
          denops,
          "<expr><S-Tab>",
          "pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<S-Tab>'",
          { mode: ["i", "c"], noremap: true },
        );
      await mapping.map(
        denops,
        "<expr><CR>",
        "pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'",
        { mode: ["i", "c"], noremap: true },
      );
      await denops.call("ddc#enable");
      await denops.call("ddc#enable_cmdline_completion");
      await autocmd.define(
        denops,
        "User",
        "DDCCmdlineLeave",
        "call ddc#enable_cmdline_completion()",
      );
    },
    afterFile: "~/.config/nvim/lua/ddc.lua",
  });

  // ddu settings
  await dvpm.add({ url: "Shougo/ddu-ui-ff" });
  await dvpm.add({ url: "Shougo/ddu-ui-filer" });
  await dvpm.add({ url: "Shougo/ddu-source-file" });
  await dvpm.add({ url: "Shougo/ddu-kind-file" });
  await dvpm.add({ url: "Shougo/ddu-source-file_rec" });
  await dvpm.add({ url: "Shougo/ddu-filter-matcher_substring" });
  await dvpm.add({ url: "Shougo/ddu-filter-sorter_alpha" });
  await dvpm.add({ url: "matsui54/ddu-source-help" });
  await dvpm.add({ url: "shun/ddu-source-buffer" });
  await dvpm.add({ url: "ryota2357/ddu-column-icon_filename" });
  await dvpm.add({
    url: "Shougo/ddu.vim",
    dependencies: [
      "Shougo/ddu-ui-ff",
      "Shougo/ddu-ui-filer",
      "Shougo/ddu-source-file",
      "Shougo/ddu-kind-file",
      "Shougo/ddu-source-file_rec",
      "Shougo/ddu-filter-matcher_substring",
      "Shougo/ddu-filter-sorter_alpha",
      "matsui54/ddu-source-help",
      "shun/ddu-source-buffer",
      "ryota2357/ddu-column-icon_filename",
    ],
    after: async ({ denops }) => {
      await denops.call("ddu#custom#patch_global", {
        ui: "ff",
        uiParams: {
          ff: {
            startAutoAction: true,
            autoAction: {
              delay: 0,
              name: "preview",
            },
            split: "floating",
            autoResize: true,
            floatingBorder: "rounded",
            winHeight: "&lines - 8",
            winWidth: "&columns / 2 - 2",
            winRow: 1,
            winCol: 1,
            previewFloating: true,
            previewFloatingBorder: "rounded",
            previewFloatingTitle: "Preview",
            previewHeight: "&lines - 8",
            previewWidth: "&columns / 2 - 2",
            previewRow: 1,
            previewCol: "&columns / 2 + 1",
          },
        },
        sources: [{ name: "file" }],
        sourceOptions: {
          _: {
            matchers: ["matcher_substring"],
            columns: ["icon_filename"],
            sorters: ["sorter_alpha"],
            volatile: true,
          },
          help: {
            defaultAction: "open",
          },
          file_rec: {
            path: "/home/riou/",
          },
        },
        kindOptions: {
          file: {
            defaultAction: "open",
          },
        },
        columnParams: {
          icon_filename: {
            defaultIcon: { icon: "" },
          },
        },
      });
      await denops.call("ddu#custom#patch_local", "help-ff", {
        sources: [{ name: "help" }],
        sourceParams: {
          helplang: "ja",
          style: "minimal",
        },
      });
      await denops.call("ddu#custom#patch_local", "buffer", {
        ui: "filer",
        sources: [{ name: "buffer" }],
      });
      await denops.call("ddu#custom#patch_local", "filer", {
        ui: "filer",
        uiParams: {
          filer: {
            split: "floating",
            floatingBorder: "rounded",
            // winHeight: "&lines - 8",
            // winWidth: "&columns / 2 - 2",
            // winRow: 1,
            // winCol: 1,
            previewFloating: true,
            previewSplit: "vertical",
            previewFloatingBorder: "rounded",
            previewFloatingTitle: "Preview",
            // previewHeight: "&lines - 8",
            // previewWidth: "&columns / 2 - 2",
            // previewRow: 1,
            // previewCol: "&columns / 2 + 1",
          },
        },
        sources: [{ name: "file" }],
        sourceOptions: {
          _: {
            columns: ["icon_filename"],
            sorters: ["sorter_alpha"],
          },
        },
        kindOptions: {
          file: {
            defaultAction: "open",
          },
        },
        actionOptions: {
          narrow: "quit",
        },
      });
    },
  });

  await dvpm.end();

  // denops.call("denops#cache#update",{reload: true});
  await nFunc.nvim_create_user_command(
    denops,
    "DenoCache",
    `call denops#cache#update(#{reload: v:true})`,
    {},
  );
  // denops.call("luaeval", 'vim.notify("Load Completed")');
  console.log("Load completed!");
}
