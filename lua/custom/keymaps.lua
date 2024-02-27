-- Custome Keymaps
-- Egil keymaps
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "ø", "b")
vim.keymap.set("n", "Ø", "B")
vim.keymap.set("n", "<leader>fe", ":Ex<CR>")

-- All/Line select
vim.keymap.set("n", "<C-l>", "V$")
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true })

-- Move line up
vim.keymap.set("n", "<A-k>", ":m-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m'<-2<CR>gv=gv", { noremap = true, silent = true })

-- Move line down
vim.keymap.set("v", "<A-j>", ":m'>+<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", ":m+<CR>==", { noremap = true, silent = true })

-- Replace all instances of hovered word
vim.keymap.set("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-W>/gI<Left><Left><Left>")

-- Half move up/do
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Buffers next/previous
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev buffer" })

-- More vscode keymaps!
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<C-y>", "<CR>")

-- ToogleTerm
vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>")
