local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
 
return function()
    -- yank to system clipboard
    keymap({ "n", "v" }, "<leader>y", '"+y', opts)
    keymap({ "n", "v" }, "<leader>p", '"+p', opts)

    -- better indent handling
    keymap("v", "<", "<gv", opts)
    keymap("v", ">", ">gv", opts)
    keymap("n", "<C-s>", ":w<CR>")

    -- paste preserves primal yanked piece
    keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

    -- Half move up/do
    keymap("n", "<C-u>", "<C-u>zz")
    keymap("n", "<C-d>", "<C-d>zz")

    -- Werid keymaps
    keymap("n", "<C-a>", "ggVG", { noremap = true })
    keymap("n", "Ø", "/\"<CR>F\"i$<Esc><Esc>", opts)
    keymap({"n","v"}, "ø","$")
end
