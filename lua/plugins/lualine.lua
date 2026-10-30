return {
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      lualine_x = { "encoding", "fileformat", "filetype" },
    },
  },
}
