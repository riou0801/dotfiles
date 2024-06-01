require("catppuccin").setup({
  transparent_background = true,
  integrations = {
    indent_blankline = {
      enabled = true,
      scope_color = "",
      colored_indent_levels = false,
    },
    noice = false,
    notify = true,
    markdown = true,
  },
  custom_highlights = function(colors)
    return {
      NotifyBackground = { bg = "#000000" }
    }
  end
})

vim.cmd[[colorscheme catppuccin-mocha]]
