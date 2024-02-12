return {
  -- add gruvbox
  { "folke/tokyonight.nvim", opts = { style = "night" } },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
