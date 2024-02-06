vim.g.mapleader = " "

-- Build in functions
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-c>", "Esc")
vim.keymap.set("n", "Q", "<nop>")

-- Lsp remaps
vim.keymap.set("n", "<leader>i", ":LspInfo<enter>")
vim.keymap.set("n", "<leader>I", ":LspInstall<enter>")

-- Hard-mode
vim.keymap.set({"n"}, "<left>", "<nop>")
vim.keymap.set({"n"}, "<right>", "<nop>")
vim.keymap.set({"n"}, "<up>", "<nop>")
vim.keymap.set({"n"}, "<down>", "<nop>")

-- Neo Tree
vim.keymap.set("n", "<leader>nt", ":Neotree<enter>")





