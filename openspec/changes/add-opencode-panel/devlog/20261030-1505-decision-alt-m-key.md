# Decision: OpenCode mode-switch key and reload approach

<!-- Section: 2/4 · Tasks: n/a · Base: f01b716 -->

- User reported `<M-m>` closed the OpenCode panel window in the Windows terminal. Likely terminal-level
  interference; moved the mode switch off it.
- Fix: in `lua/plugins/opencode.lua` opts, `keymap.input_window` now sets
  - `["<M-m>"] = false`
  - `["<leader>om"] = { "switch_mode", mode = { "n", "i" } }`
- Verified headlessly: resolved config has `<leader>om → { "switch_mode", mode = { "n", "i" } }`; `<M-m>`
  unbound in insert mode; `:messages` clean. `GATES_EXIT:0`.

## Next

- Answer the user's reload question, then continue §4.1 human verification in real Neovim.
