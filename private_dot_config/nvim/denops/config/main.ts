import * as fn from "https://deno.land/x/denops_std@v6.5.0/function/mod.ts";
import * as mapping from "https://deno.land/x/denops_std@v6.5.0/mapping/mod.ts";
import { Denops } from "https://deno.land/x/denops_std@v6.5.0/mod.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.18.1/mod.ts";
import { execute } from "https://deno.land/x/denops_std@v6.5.0/helper/mod.ts";
// import { options } from "https://deno.land/x/denops_std@v6.5.0/variable/mod.ts";
import { Dvpm } from "https://deno.land/x/dvpm@3.12.0/mod.ts";
import * as vars from "https://deno.land/x/denops_std@v6.5.0/variable/mod.ts";
import * as autocmd from "https://deno.land/x/denops_std@v6.5.0/autocmd/mod.ts";
import * as nFunc from "https://deno.land/x/denops_std@v6.5.0/function/nvim/mod.ts";

export async function main(denops: Denops): Promise<void> {
  // プラグインをインストールするベースとなるパスです。
  const base_path = (await fn.has(denops, "nvim")) ? "~/.cache/nvim/dvpm" : "~/.cache/vim/dvpm";
  const base = ensure(await fn.expand(denops, base_path), is.String);
  // const cache_path = (await fn.has(denops, "nvim"))
  //  ? "~/.config/nvim/plugin/dvpm_plugin_cache.vim"
  //  : "~/.config/vim/plugin/dvpm_plugin_cache.vim";
  // This cache path must be pre-appended to the runtimepath.
  // Add it in vimrc or init.lua by yourself, or specify the path originally added to
  // runtimepath of Vim / Neovim.
  //const cache = ensureString(await fn.expand(denops, cache_path));
  //
  // ベースパスを引数に、 Dvpm.begin を実行して、 `dvpm` インスタンスを取得します。
  const dvpm = await Dvpm.begin(denops, { base });

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
    afterFile: "~/.config/nvim/lua/nvim-catppuccin.lua",
  });
  await dvpm.add({ url: "nvim-tree/nvim-web-devicons" });
  await dvpm.add({
    url: "goolord/alpha-nvim",
    dependencies: [{ url: "nvim-tree/nvim-web-devicons" }],
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
        zindex: 999,
      });
      // await mapping.map(
      //   denops,
      //   ":",
      //   "<Cmd>call cmdline#input()<CR>",
      //   { mode: "n" })
    },
  });
  await dvpm.add({ 
    url: "lambdalisue/vim-fall",
    enabled: true
  });
  await dvpm.add({
    url: "rcarriga/nvim-notify",
    afterFile: "~/.config/nvim/lua/nvim-notify.lua",
  });
  // await dvpm.add({
  //   url: "folke/noice.nvim",
  //   dependencies: [
  //     { url: "MunifTanjim/nui.nvim" },
  //     { url: "rcarriga/nvim-notify" },
  //   ],
  //   after: async ({ denops }) => {
  //     await execute(
  //       denops,
  //       `
  //       lua << EOF
  //         require("noice").setup({
  //         presets = {
  //         bottom_search = false, -- use a classic bottom cmdline for search
  //         command_palette = true, -- position the cmdline and popupmenu together
  //         long_message_to_split = true, -- long messages will be sent to a split
  //         inc_rename = false, -- enables an input dialog for inc-rename.nvim
  //         lsp_doc_border = true, -- add a border to hover docs and signature help
  //           },
  //         })
  //       EOF
  //       `,
  //     );
  //   },
  // });
  await dvpm.add({
    url: "nvim-lualine/lualine.nvim",
    after: async ({ denops }) => {
      await execute(
        denops,
        `lua << EOF
        require("lualine").setup({
          options = {
            theme = "catppuccin"
          }
        })
        EOF
        `,
      );
    },
  });
  await dvpm.add({
    url: "luukvbaal/statuscol.nvim",
    after: async ({ denops }) => {
      await denops.call("luaeval", `require("statuscol").setup()`);
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
      await vars.globals.set(denops, "chronicle_read_path", "/home/riou/.cache/chronicle/read");
      await vars.globals.set(denops, "chronicle_write_path", "/home/riou/.cache/chronicle/write");
    },
    after: async ({ denops }) => {
      await mapping.map(
        denops,
        "mr",
        "<Cmd>OpenChronicleRead<CR>",
        { mode: [ "n" ] },
      ),
      await mapping.map(
        denops,
        "mw",
        "<Cmd>OpenChronicleWrite<CR>",
        { mode: [ "n" ]},
      )
    }
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
      await denops.call("luaeval", 'require("ibl").setup()');
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
    enabled: false,
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
    dependencies: [{ url: "vim-denops/denops.vim" }],
    // afterFile: "~/.config/nvim/lua/snippet.lua", 
    after: async ({ denops }) => {
      await mapping.map(
        denops,
        "<C-l>",
        "<Plug>(denippet-expand)",
        { mode: ["i"] },
      ),
      await mapping.map(
        denops,
        "<expr><Tab>",
        "denippet#jumpable() ? '<Plug>(denippet-jump-next)' : '<Tab>'",
        { mode: ["i", "s"] },
      ),
      await mapping.map(
        denops,
        "<expr><S-Tab>",
        "denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-Tab>'",
        { mode: ["i", "s"] },
      );
    },
  }),
  await dvpm.add({
    url: "ryoppippi/denippet-autoimport-vscode",
    dependencies: [{ url:"uga-rosa/denippet.vim" }]
  }),
  await dvpm.add({ 
    url: "rachartier/tiny-inline-diagnostic.nvim",
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("tiny-inline-diagnostic").setup()');
    },
  });

  // await dvpm.add({ url: "nil70n/floating-help" });

  // LSP etc
  await dvpm.add({
    url: "folke/neodev.nvim",
    dependencies: [{ url: "neovim/nvim-lspconfig" }],
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("neodev").setup()');
    },
  });
  await dvpm.add({
    url: "ionide/ionide-vim",
    dependencies: [{ url: "neovim/nvim-lspconfig" }],
  });
  await dvpm.add({
    url: "sigmaSd/deno-nvim",
    dependencies: [{ url: "neovim/nvim-lspconfig" }],
    after: async ({ denops }) => {
      await denops.call("luaeval", 'require("deno-nvim").setup()');
    },
  });
  await dvpm.add({
    url: "neovim/nvim-lspconfig",
    afterFile: "~/.config/nvim/lua/nvim-lspconfig.lua",
  });
  // denops-ollama
  await dvpm.add({ url: "kyoh86/denops-ollama.vim" });

  // ddc settings
  await dvpm.add({
    url: "Shougo/ddc.vim",
    dependencies: [
      // ui
      { url: "Shougo/ddc-ui-native" },
      { url: "Shougo/ddc-ui-pum" },
      {
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
      },
      // source
      { url: "LumaKernel/ddc-source-file" },
      { url: "Shougo/ddc-source-line" },
      { url: "Shougo/ddc-source-around" },
      { url: "Shougo/ddc-source-input" },
      { url: "Shougo/ddc-source-lsp" },
      { url: "Shougo/ddc-source-cmdline" },
      { url: "Shougo/ddc-source-cmdline-history" },
      { url: "Shougo/ddc-source-shell-native" },
      { url: "uga-rosa/ddc-source-nvim-lua" },
      // filter sorter and matcher
      { url: "tani/ddc-fuzzy" },
      { url: "Shougo/ddc-filter-matcher_head" },
      { url: "Shougo/ddc-filter-sorter_rank" },
      { url: "Shougo/ddc-filter-matcher_length" },
      { url: "Shougo/ddc-filter-converter_truncate_abbr" },
      { url: "matsui54/ddc-postfilter_score" },
      
      {
        url: "uga-rosa/ddc-previewer-floating",
        enabled: false,
        after: async ({ denops }) => {
          await execute(
            denops,
            `lua << EOF
              require('ddc_previewer_floating').setup({
                ui = "pum",
                max_height = 40,
                max_width = 56,
                border = "rounded",
                zindex = 950,
                window_options = {
                  wrap = false
                },
              })
            EOF
            `,
          );
        },
      },
      {
        url: "uga-rosa/ddc-source-lsp-setup",
        dependencies: [{ url: "neovim/nvim-lspconfig" }],
        after: async ({ denops }) => {
          await execute(denops, `lua require("ddc_source_lsp_setup").setup()`);
        },
      },
    ],
    after: async ({ denops }) => {
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
        sources: ["lsp", "denippet", "nvim-lua", "around"],
        cmdlineSources: {
          ":": ["cmdline", "cmdline-history", "shell-native", "file", "around"],
          "@": ["input", "cmdline-history", "file", "around"],
          ">": ["input", "cmdline-history", "file", "around"],
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
          "cmdline-history": { mark: "c-his" },
          "shell-native": { mark: "fish" },
          around: { mark: "around" },
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
        },
        sourceParams: {
          line: { maxSize: 250 },
          "shell-native": { shell: "fish" },
          lsp: {
            // snippetEngine: "denops#callback#register({ body -> denippet#anonymous(body) })",
            snippetEngine: async (body: string) => {
              await denops.call("denippet#anonymous", body);
            },
            enableResolveItem: true,
            enableAdditionalTextEdit: true,
          },
        },
        postFilters: ["postfilter_score"],
        filterParams: {
          postfilter_score: {
            showScore: true,
          },
          converter_truncate_abbr: {
            maxAbbrWidth: 60,
          },
        },
      }),
      // await mapping.map(
      //   denops,
      //   "<expr><Down>",
      //   "pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Down>'",
      //   { mode: ["i", "c"] },
      // ),
      await mapping.map(
        denops,
        "<expr><Tab>",
        "pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Tab>'",
        { mode: ["i", "c"] },
      ),
      // await mapping.map(
      //   denops,
      //   "<expr><Up>",
      //   "pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Up>'",
      //   { mode: ["i", "c"] },
      // ),
      await mapping.map(
        denops,
        "<expr><S-Tab>",
        "pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<S-Tab>'",
        { mode: ["i", "c"] },
      ),
      await mapping.map(
        denops,
        "<expr><CR>",
        "pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'",
        { mode: ["i", "c"] },
      ),
      await denops.call("ddc#enable"),
      await denops.call("ddc#enable_cmdline_completion"),
      await autocmd.define(
        denops,
        "User",
        "DDCCmdlineLeave",
        "call ddc#enable_cmdline_completion()",
      )
    }
  });

  // ddu settings
  await dvpm.add({
    url: "Shougo/ddu.vim",
    dependencies: [
      { url: "Shougo/ddu-ui-ff" },
      { url: "Shougo/ddu-ui-filer" },
      { url: "Shougo/ddu-source-file" },
      { url: "Shougo/ddu-kind-file" },
      { url: "Shougo/ddu-source-file_rec" },
      { url: "Shougo/ddu-filter-matcher_substring" },
      { url: "Shougo/ddu-filter-sorter_alpha" },
      { url: "matsui54/ddu-source-help" },
      { url: "shun/ddu-source-buffer" },
      { url: "ryota2357/ddu-column-icon_filename" },
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
            startFilter: true,
            winWidth: "&columns / 2 - 2",
            previewFloating: true,
            previewFloatingBorder: "rounded",
            previewFloatingTitle: "Preview",
            previewHeight: "&lines - 8",
            previewWidth: "&columns / 2 - 2",
            // previewRow: 1,
            // previewCol: "&columns / 2 + 1",
          },
        },
        sources: [{ name: "file" }],
        sourceOptions: {
          _: {
            matchers: ["matcher_substring"],
            columns: ["icon_filename"],
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
      }),
      await denops.call("ddu#custom#patch_local", "help-ff", {
        sources: [{ name: "help" }],
        sourceParams: {
          helplang: "ja",
          style: "minimal",
        },
      }),
      await denops.call("ddu#custom#patch_local", "buffer", {
        ui: "filer",
        sources: [{ name: "buffer" }],
      }),
      await denops.call("ddu#custom#patch_local", "filer", {
        ui: "filer",
        uiParams: {
          filer: {
            split: "floating",
            floatingBorder: "rounded",
            winHeight: "&lines - 8",
            winWidth: "&columns / 2 - 2",
            winRow: 1,
            winCol: 1,
            previewFloating: true,
            previewSplit: "vertical",
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
