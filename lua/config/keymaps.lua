-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps herlie
--

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "ø", "b")
vim.keymap.set("n", "Ø", "B")

vim.keymap.set("n", "<C-l>", "V$")
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true })

-- Move line up
vim.keymap.set("n", "<A-k>", ":m-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m'<-2<CR>gv=gv", { noremap = true, silent = true })

-- Move line down
vim.keymap.set("n", "<A-j>", ":m+<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", ":m'>+<CR>gv=gv", { noremap = true, silent = true })
