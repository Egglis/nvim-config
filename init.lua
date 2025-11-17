
require("options.options")

local shared_keymaps = require('keymaps.shared')

if type(shared_keymaps) == 'function' then
  shared_keymaps()
end

if vim.g.vscode then
  print('Using VS Code Keymaps...')
  local vscode_keymaps = require('keymaps.vscode')
  if type(vscode_keymaps) == 'function' then
    vscode_keymaps()
  end
else
  print('Using Regular Neovim Keymaps...')
  local regular_keymaps = require('keymaps.regular')
	if type(regular_keymaps) == 'function' then
		regular_keymaps()
		require("lazy.init_lazy")
  end
end

