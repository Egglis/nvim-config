local key_hints = require("config.key_hints")

local opts = {
  -- Turned on from the saved state in `config` below, not by hardtime's own delayed setup.
  enabled = false,
  -- hardtime turns the mouse off while it runs by default.
  disable_mouse = false,
  -- Pickers, the explorer, terminals and lazygit (snacks), and the OpenCode panel move freely.
  disabled_filetypes = { ["snacks_.*"] = true, ["opencode.*"] = true },
}

local function apply(on)
  if on then
    require("hardtime").enable()
  else
    require("hardtime").disable()
  end
end

return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  -- Loads at startup only when saved on; otherwise on its toggle key.
  event = key_hints.get("hardtime") and "VeryLazy" or nil,
  keys = {
    {
      "<leader>uh",
      function()
        key_hints.toggle("hardtime", apply)
      end,
      desc = "Toggle hardtime (habit trainer)",
    },
  },
  opts = opts,
  config = function(_, o)
    -- hardtime.setup() applies the options 500 ms later; set them now so an enable() before then uses them.
    local config = require("hardtime.config")
    config.config = vim.tbl_deep_extend("force", config.config, o)
    require("hardtime").setup(o)
    if key_hints.get("hardtime") then
      apply(true)
    end
  end,
}
