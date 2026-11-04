local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function with_desc(base, desc)
  return vim.tbl_extend("force", base, { desc = desc })
end

return function()
  -- yank to system clipboard
  keymap({ "n", "v" }, "<leader>y", '"+y', with_desc(opts, "Yank to system clipboard"))
  keymap({ "n", "v" }, "<leader>p", '"+p', with_desc(opts, "Paste from system clipboard"))

  -- better indent handling
  keymap("v", "<", "<gv", with_desc(opts, "Indent left, keep selection"))
  keymap("v", ">", ">gv", with_desc(opts, "Indent right, keep selection"))
  keymap("n", "<C-s>", ":w<CR>", { desc = "Save file" })

  -- paste preserves primal yanked piece
  keymap("n", "<Esc>", "<Esc>:noh<CR>", with_desc(opts, "Clear search highlight"))

  -- Half move up/do
  keymap("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })
  keymap("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })

  -- E and B
  keymap({ "n", "v" }, "B", "0w", { desc = "Jump to first word of line" })
  keymap({ "n", "v" }, "E", "$", { desc = "Jump to end of line" })

  -- Weird keymaps
  keymap("n", "<C-a>", "ggVG", { noremap = true, desc = "Select all" })
  keymap("n", "Ø", '/"<CR>F"i$<Esc><Esc>', with_desc(opts, "Jump into next quoted string"))
end
