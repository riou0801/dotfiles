require("lualine").setup({
  options = {
    always_show_tabline = false,
    theme = "catppuccin"
  },
  sections = {
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    }
  },
  tabline = {
    lualine_a = {
      {
        "buffers",
        mode = 4,
      }
    },
  }
})
