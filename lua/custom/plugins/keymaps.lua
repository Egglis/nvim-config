

-- Custome Keymaps
-- Egil keymaps
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "ø", "b")
vim.keymap.set("n", "Ø", "B")
vim.keymap.set("n", "<leader>fe", ":Ex<enter>")

-- All/Line select 
vim.keymap.set("n", "<C-l>", "V$")
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true })

-- Move line up
vim.keymap.set("n", "<A-k>", ":m-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m'<-2<CR>gv=gv", { noremap = true, silent = true })

-- Move line down
vim.keymap.set("n", "<A-j>", ":m+<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", ":m'>+<CR>gv=gv", { noremap = true, silent = true })

-- Replace all instances of hovered word
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-W>/gI<Left><Left><Left>")

-- Half move up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")











