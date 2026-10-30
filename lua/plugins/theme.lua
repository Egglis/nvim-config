return {
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("tokyonight").setup({
      style = "night",

      on_highlights = function(hl, colors)
        hl.LineNrAbove = { fg = colors.blue, bold = true }
        hl.LineNrBelow = { fg = colors.blue, bold = true }
      end,
    })
    require("tokyonight").load()
  end,
}
