local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.opt.clipboard = 'unnamedplus'

return function()
		keymap({"n","v"}, "<leader>y", "\"+y")
		keymap({"n","v"}, "<C-s>", ":w<CR>")
end
