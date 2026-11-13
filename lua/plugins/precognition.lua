local key_hints = require("config.key_hints")

local function apply(on)
  if on then
    require("precognition").show()
  else
    require("precognition").hide()
  end
end

return {
  "tris203/precognition.nvim",
  -- Loads at startup only when saved on; otherwise on its toggle key.
  event = key_hints.get("precognition") and "VeryLazy" or nil,
  keys = {
    {
      "<leader>up",
      function()
        key_hints.toggle("precognition", apply)
      end,
      desc = "Toggle motion hints (precognition)",
    },
  },
  opts = function()
    return { startVisible = key_hints.get("precognition") }
  end,
}
