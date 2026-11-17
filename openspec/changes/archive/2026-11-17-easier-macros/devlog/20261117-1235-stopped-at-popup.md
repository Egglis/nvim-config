# Stopped in section 2: the `@` popup breaks quick `@@`

<!-- Section: 2 · Task: 2.1 · Base: 4e73ddb · Uncommitted: lua/plugins/which-key.lua -->

Done (uncommitted): `lua/plugins/which-key.lua` spec entry
`{ "@", mode = "n", plugin = "registers", desc = "run macro" }`.

What works (headless over RPC; which-key needs `require("lazy").load({plugins={"which-key.nvim"}})`
headless, since `VeryLazy` doesn't fire without a UI):
- `nmap @` is which-key's trigger (`which-key-trigger registers`); `xmap @` is still Neovim's
  `v_@-default`.
- `@` opens the popup (2 floats); `q` closes it and runs the macro; `3@q` runs it 3 times; `@q` sent in one
  batch works; `@q` then `@@` with ≥0.3 s between keys works.

What breaks: register `q` = `A;<Esc>j`, lines `a..e`, keys `@ q @ @ @ @ @ @` with **0.15 s** between
keys (normal typing speed):
- with the trigger: `a;,b,c;,d,e;` (lines skipped, wrong edits);
- base commit (no trigger), same keys: `a;,b;,c;,d;,e` (correct).
`vim.on_key` log: after the macro runs, `reg_executing()` is still `q` when the next typed `@` arrives;
the trigger fires anyway and a stray `<Cmd>…<CR>` pair goes through, and that `<CR>` moves the cursor
one line down. which-key keeps triggers suspended while `in_macro()` (re-checking every 100 ms), so the
result depends on timing. That's the design's Risk "which-key `@` trigger and counts" → stop and ask.

Question for the user: (A) drop the `@` popup (the `<leader>fm` picker shows macros, `"` still shows
registers), (B) a custom `@` map that falls back to plain `@` while a macro is running/recording and
otherwise opens the popup (more code and still a remap of `@`), or (C) keep it and accept the race.
Recommended: A.

## Next

- Apply the user's answer to §2 (A: revert `which-key.lua`, update design decision 2, the spec's
  "Register list when replaying" requirement and tasks 2.1/2.2, plus proposal), then §3 task 3.1.
