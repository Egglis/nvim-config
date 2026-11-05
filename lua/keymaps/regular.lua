-- Standalone-only mappings. Mappings shared with VSCode live in keymaps/shared.lua.
return function()
  vim.keymap.set("n", "<M-q>", "<cmd>b#<CR>", { desc = "Go back to the last buffer" })
end
