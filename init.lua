require("config.options")
require("keymaps.shared")()

if vim.g.vscode then
  require("keymaps.vscode")()
else
  require("keymaps.regular")()
  require("config.lazy")
end
