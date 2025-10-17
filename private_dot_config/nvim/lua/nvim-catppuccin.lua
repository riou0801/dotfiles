require("catppuccin").setup({
  transparent_background = true,
  float = {
    transparent = true,
    solid = false
  },
  integrations = {
    indent_blankline = {
      enabled = true,
      scope_color = "text",
      colored_indent_levels = false,
    },
    noice = false,
    notify = true,
    markdown = true,
    fzf = true,
    treesitter = true,
    render_markdown = true,
  },
  custom_highlights = function(colors)
    return {
      Pmenu = { bg = colors.base },
      NormalFloat = { bg = colors.base },
      FloatBorder = { bg = colors.base },
      NotifyBackground = { bg = "#000000" },
      -- modes.nvim custom_highlights
      ModesCopy = { bg = colors.yellow },
      ModesDelete = { bg = colors.maroon },
      -- ModesChange = ModesDelete,
      ModesFormat = { bg = colors.teal },
      ModesInsert = { bg = colors.green },
      ModesReplace = { bg = colors.mauve },
      -- ModesSelect = ModesVisual,
      ModesVisual = { bg = colors.lavender }
    }
  end
})

vim.cmd.colorscheme("catppuccin-mocha")
