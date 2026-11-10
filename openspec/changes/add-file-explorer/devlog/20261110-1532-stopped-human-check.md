# Stopped: human check of the float explorer (§3.1)

<!-- Section: 3 · Tasks: 3.1 · Base: c7f35dd -->

§1–§2 are committed and pushed (`c7f35dd`). 3.1 needs the user in real Neovim and VSCode. Recipe given
to the user, in this repo (`nvim lua/config/options.lua` from the config folder):

1. `<leader>fe`: a centred float opens, the tree on the left on `options.lua`, its preview on the right.
2. `j`/`k`: the preview follows. `P` hides it, `P` shows it again.
3. `<CR>` on a folder expands it; `<CR>` on a file opens it and the float closes. `<leader>fe` reopens it
   on that file. `<leader>fe` again closes it.
4. `a` → `test.md`, then `a` → `testdir/`: a file and a folder appear.
5. `r` on `test.md` → `test2.md`: renamed.
6. `d` on `test2.md`: asks first; after yes it's in the Windows Recycle Bin. Same for `testdir`.
7. Edit and save a tracked file, reopen the tree: the file has a git mark.
8. `Ctrl+c` closes; `q` closes; `<Esc>` doesn't.
9. `<C-t>` in the tree: the terminal opens/focuses (the float closes as you leave it).
10. VSCode: `<leader>fe` still focuses VSCode's own explorer.

Question: does each step behave as described, and does the float with the preview feel right?

## Next

- Record the user's answers in a new note. All good → tick 3.1, commit, then the whole-change review
  (first base `d1c1ced`), change-done note, offer an independent review, offer `/opsx-archive`.
- Any failure or "feels wrong" → agree a fix section (`## 4. Review fixes: …`) with the user first.
