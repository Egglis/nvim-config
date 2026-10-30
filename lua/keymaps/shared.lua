local keymap = vim.keymap.set

return function()
  -- System clipboard
  keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
  keymap({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

  -- Keep selection when indenting
  keymap("v", "<", "<gv", { desc = "Indent left" })
  keymap("v", ">", ">gv", { desc = "Indent right" })

  keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
  keymap("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

  -- Keep the cursor centred when scrolling and searching
  keymap("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centred)" })
  keymap("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centred)" })
  keymap("n", "n", "nzzzv", { desc = "Next match (centred)" })
  keymap("n", "N", "Nzzzv", { desc = "Previous match (centred)" })

  -- Line start/end
  keymap({ "n", "v" }, "B", "0w", { desc = "First word of line" })
  keymap({ "n", "v" }, "E", "$", { desc = "End of line" })

  keymap("n", "<C-a>", "ggVG", { desc = "Select all" })
  -- Norwegian keyboard: jump into the next quoted string
  keymap("n", "Ø", '/"<CR>F"i$<Esc><Esc>', { silent = true, desc = "Jump into next quoted string" })
end
