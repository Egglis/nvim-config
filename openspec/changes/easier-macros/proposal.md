# Proposal

## Why

The readme TODO "Easier macros" is open: macros feel hard to use. The user can't easily tell whether
recording is on, can't see what a register holds before replaying it, and has no way to view or fix a
macro afterwards. The user wants this to stay **as close to default Vim/Neovim as possible**.

Research (see design.md) found that Neovim 0.12 already has the simple flow: `qq … q` to record, then
`Q` replays the last recorded macro (with a count), `@@` repeats the last one run, and in linewise
visual mode `Q`/`@q` run the macro on each selected line. What's missing is making macros visible and
editable. The user chose "defaults + small glue" over `chrisgrieser/nvim-recorder`, which takes over `q`.

## What Changes

- **Recording indicator** (standalone): while a macro is being recorded, the statusline shows a
  bright `REC @q` block; it disappears as soon as recording stops. This also covers a future
  `cmdheight=0`, which hides Neovim's own "recording @q" message.
- **Register list on `@`** (standalone, normal mode): with the key-hints popup on, pressing `@` shows
  the registers and their contents, like which-key already does for `"`. Pressing a register key runs
  that macro as usual. Visual `@` (Neovim's run-on-each-line) is untouched.
- **Macro picker `<leader>fm`** (standalone): a snacks picker of the `a`–`z` registers that hold
  something, shown readably (`<Esc>`, `<CR>` …) with a preview. `<CR>` runs the macro in the window you
  came from; `<C-e>` opens it in a small editor float, where `:w` saves the edited keys back into the
  register.
- No change to `q`, `Q`, `@`, `@@` or any default macro behaviour; nothing in `shared.lua` or
  `vscode.lua`.
- Docs: `AGENTS.md` (a Macros section with the built-in flow, the new keys, the plugin row's lazy keys,
  the which-key note), readme TODO ticked.

Out of scope: nvim-recorder or any new plugin, macro slots, breakpoints, saving macros across restarts
beyond Neovim's own ShaDa (named registers already persist), `cmdheight=0` itself (the "Less clutter"
TODO), and VSCode mode.

## Capabilities

### New Capabilities

- `macros`: recording indicator, register list on `@`, the macro picker and the macro editor, while the
  default macro keys keep working.

### Modified Capabilities

None. The picker spec's general rules (closing, on-demand loading, absent in VSCode) apply to the new
picker as written.

## Impact

- `lua/plugins/lualine.lua` (indicator component + refresh on `RecordingEnter`/`RecordingLeave`),
  `lua/plugins/which-key.lua` (`@` register trigger), `lua/plugins/snacks.lua` (`<leader>fm` key and
  a `macros` source), a new `lua/config/macros.lua` (list/format/edit helpers, no plugin requires at
  load time).
- No new plugins or dependencies; `docs/dependencies.md`, `gates.ps1`, `gates.sh` unchanged.
- `AGENTS.md`, `readme.md`.
