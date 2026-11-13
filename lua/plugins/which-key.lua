return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>uw",
      function()
        require("config.key_hints").toggle("whichkey")
      end,
      desc = "Toggle key hints popup (which-key)",
    },
  },
  opts = {
    preset = "classic",
    -- which-key has no off switch: while off, the popup waits ~11 days, so keys work as without it.
    delay = function(ctx)
      if not require("config.key_hints").get("whichkey") then
        return 1e9
      end
      return ctx.plugin and 0 or 200
    end,
    spec = {
      { "<leader>b", group = "buffers" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>n", group = ".NET" },
      { "<leader>o", group = "opencode" },
      { "<leader>q", group = "session" },
      { "<leader>t", group = "terminal" },
      { "<leader>u", group = "toggles" },
    },
  },
}
