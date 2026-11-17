# Design

## Context

What the research found, on Neovim 0.12.6 with the pinned plugins:

- **Built-in macros already cover "simple keys".** `q{reg}` records and `q` stops. `@{reg}` runs a
  register, `@@` repeats the last one run, and `Q` (Neovim default) replays the **last recorded**
  register, with a count. Since 0.10, linewise visual `@{reg}` / `Q` run the macro on each selected line
  (`:h v_@-default`, `:h v_Q-default`, defined as `x` expr maps by Neovim). Named registers persist across
  restarts through ShaDa.
- **Recording status** is shown only as "recording @q" in the command line (with `showmode`). The
  "Less clutter" TODO plans `cmdheight=0`, which would hide it. lualine has no built-in recording
  component; `vim.fn.reg_recording()` gives the register, and `RecordingEnter`/`RecordingLeave` fire on
  start/stop. During `RecordingLeave` `reg_recording()` still returns the register.
- **which-key** (`which-key.nvim`, v3) ships a `registers` plugin that is already on: it pops up on `"`
  (n, x) and `<C-r>` (i, c), listing non-empty registers with their contents. It is not wired to `@`.
  A user spec entry with `plugin = "registers"` creates a trigger for that plugin (handled in
  `mappings.lua`/`tree.lua`). The config's `delay` already returns 0 for plugin popups and 1e9 when the
  key-hints popup is toggled off.
- **snacks** ships a `registers` source (finder `vim_registers`, items `{ reg, data, value, preview }`,
  confirm = copy). It lists every register (`"`, `+`, `.`, …), not only macros, and shows raw text.
- **chrisgrieser/nvim-recorder** (the main macro plugin): `q` toggles recording into "slots", `Q` plays,
  `<C-q>` switches slot, `cq`/`yq`/`dq` edit/yank/delete, `##` breakpoints, lualine components. It
  replaces `q{reg}`, and its own readme notes that Neovim's `Q` already covers the "fewer keys" part.
  **NeoComposer** is heavier still (sqlite, its own UI). The user chose neither: defaults + small glue.

## Goals / Non-Goals

**Goals:**
- You always know when you're recording.
- You can see what's in a register before running it.
- You can list, run and fix saved macros without `:let @q = …` tricks.

**Non-Goals:**
- New macro keys or slots; any remap of `q`, `Q`, `@`, `@@`.
- Breakpoints, a macro library, or anything in VSCode mode.
- `cmdheight=0` (separate TODO); this change only makes it safe for macros.

## Decisions

1. **Recording indicator: a lualine component in `lualine_a`, right after `mode`.** A function returning
   `"REC @" .. reg` while `reg_recording() ~= ""`, else `""` (lualine hides empty components). It gets a
   fixed, loud colour (fg/bg taken from tokyonight's error colour via a highlight group such as
   `DiagnosticError`'s fg as background), so it stands out from the repo accent block next to it.
   - **Refresh:** lualine only refreshes on its timer and some events, so a `RecordingEnter` /
     `RecordingLeave` autocmd (group in the lualine spec's `config`) calls `require("lualine").refresh()`.
     On `RecordingLeave` the refresh is `vim.schedule`d, because `reg_recording()` is still set during the
     event.
   - Lives in `lua/plugins/lualine.lua` next to `searchcount`. `repo_accent.attach_lualine()` keeps owning
     `lualine.setup()`; the component is just part of `opts.sections`.
   - Rejected: relying on Neovim's "recording @q" message (gone with `cmdheight=0`); `noice.nvim` (heavy).
2. **No `@` register popup (dropped in §2, user's call).** The plan was one which-key spec entry
   `{ "@", mode = "n", plugin = "registers" }`. It works for `@q`, `3@q` and slow `@@`, but `@q` then
   `@@ @@ @@` typed ~150 ms apart edited the wrong lines (`a;,b,c;,d,e;` instead of `a;,b;,c;,d;,e`):
   after a macro `reg_executing()` stays set until the next typed key, which-key's trigger fires in that
   state and a stray `<Cmd>…<CR>` moves the cursor down. A custom `@` map with a fallback was offered and
   declined (still a remap of `@`). `@` stays fully default; the picker (decision 3) shows the macros,
   and which-key's existing `"` popup lists registers.
3. **Macro picker `<leader>fm`: a custom snacks source `macros` in `opts.picker.sources`.** `fm` = "find
   macros", free in both standalone and (unused) VSCode keymaps, under the existing `f` group.
   - `finder`: registers `a`–`z` with non-empty content; `text`/`value` = `vim.fn.keytrans(getreg(r))`
     (readable: `<Esc>`, `<CR>`, `<lt>`), `preview.text` the same readable text. Same `register` format as
     snacks' `registers` source. Built in `lua/config/macros.lua` so it can be tested without the picker.
   - `confirm`: close the picker, then, scheduled so it runs in the original window in normal mode, feed
     `@{reg}` (`nvim_feedkeys("@q", "n", …)`), so a mapping on `@` can never catch it. The register's
     contents are still remappable, as with a typed `@q` (verify headless with a macro that uses a user
     mapping).
   - `<C-e>` (input `i`/`n`, list) → the edit action (decision 4).
   - Layout: the shared preset rule the other centred pickers use. Lazy key in `plugins/snacks.lua` with
     `desc`, so snacks still loads on demand.
   - Rejected: reusing `Snacks.picker.registers()` (lists every register, confirm copies instead of runs);
     a `<leader>m` group (one more group for one key).
4. **Editor: a small float from `lua/config/macros.lua`, `buftype=acwrite`.** It holds the readable form
   (`keytrans`) on one line; the buffer is named `macro://q` so `:w` works, and a `BufWriteCmd` autocmd
   does `vim.fn.setreg(reg, vim.keycode(text))` (keeping the register's type as charwise), clears
   `modified` and notifies `Saved macro @q`. `q`/`<Esc>` in normal mode close it (`:q!` too); closing
   without `:w` leaves the register as it was.
   - `keytrans` → `keycode` round-trips the usual macro content: special keys, `<lt>` for a literal `<`,
     and multi-byte text. A literal newline in the register becomes `<NL>`/`<CR>` and back.
   - Rejected: editing the raw register text (`"qp` … `"qyy`) — escape characters are invisible and the
     trailing newline turns it linewise, which is the "difficult" part today.
5. **Everything is standalone-only** by placement: lualine, which-key and snacks never load in VSCode,
   and `lua/config/macros.lua` is only required from inside those specs' functions. `shared.lua` and
   `vscode.lua` are untouched.

## Risks / Trade-offs

- [Typed keys racing a just-finished macro] → that's what sank the `@` popup (decision 2); nothing in this
  change maps `q`, `Q` or `@` any more. §3 re-runs the quick `@q @@ @@ @@` check.
- [Running a macro from the picker in the wrong window/mode] → schedule it after close and check
  `nvim_get_current_win()` equals the window the picker started from.
- [Macros that contain mapped keys behave differently when run from the picker] → only the `@` is fed
  non-remapped; a headless check confirms the contents still use mappings, like a typed `@q`.
- [Recording indicator colour clashing with the repo accent] → it's a fixed error-red; human check
  decides, colour is one line to change.

## Open Questions

None.
