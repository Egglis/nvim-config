require("config.options")
require("keymaps.shared")()

if vim.g.vscode then
  require("keymaps.vscode")()
else
  require("keymaps.regular")()
  require("config.repo_accent").setup()
  require("config.session").setup()
  require("config.lazy")
end
