return {
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  opts = function()
    return {
      options = {
        icons_enabled = true,
        theme = "auto", -- replaced by repo_accent's tinted copy of the auto theme
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { require("config.repo_accent").component(), "mode" },
        lualine_x = { "encoding", "fileformat", "filetype" },
      },
    }
  end,
  config = function(_, opts)
    require("config.repo_accent").attach_lualine(opts)
  end,
}
