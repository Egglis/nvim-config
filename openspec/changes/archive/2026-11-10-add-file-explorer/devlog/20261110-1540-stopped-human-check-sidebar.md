# Stopped: human check of the sidebar (§5.1)

<!-- Section: 5 · Tasks: 5.1 · Base: 5d1888f -->

§4 committed and pushed (`5d1888f`). Recipe given to the user (`nvim lua/config/options.lua` in the
config folder):

1. `<leader>fE`: a 40-column tree on the right, cursor on `options.lua`; the editor window shows its
   preview.
2. `j`/`k`: the editor-window preview follows. `P` hides it, `P` shows it again.
3. `<CR>` on a file: it opens in the editor and the sidebar stays open.
4. `<C-w>h` into the editor: your file, no preview over it. `<C-w>l` back into the tree: the preview
   returns.
5. `<leader>fE` closes it. `<leader>fE` again, then `<leader>fe`: closes it too.
6. `<leader>fe` still opens the float as before.

Question: does each step behave as described, and does the sidebar's preview-over-the-editor feel right?

## Next

- Record the answers. All good → tick 5.1, commit, then the whole-change review (first base `d1c1ced`),
  change-done note, offer an independent review, offer `/opsx-archive`.
- Any failure or "feels wrong" → agree a fix section (`## 6. Review fixes: …`) with the user first.
