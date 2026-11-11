# Proposal

## Why

The readme TODO "Better search in the current file than the standard `/`" is open. Today `/` only shows
the match under the cursor while typing: `hlsearch` is off, so after `<CR>` the other matches aren't
visible, `n`/`N` can land at the screen edge, and the `[2/7]` count lives only in the command line (which
the "Less clutter" TODO wants to hide with `cmdheight=0`). There is also no way to see all matching lines
at once and jump to one, like VSCode's Periscope "search current file" that the user has on `<leader>ff`
in VSCode.

Research (see design.md) compared polishing the built-in search, snacks' `lines` picker (already
installed), flash.nvim (jump labels) and nvim-hlslens (per-match counts). The user chose the first two:
no new plugins.

## What Changes

- **Matches stay highlighted** (standalone only): `hlsearch` on, so after a search every match stays
  highlighted until `<Esc>` (already mapped to `:noh` in both environments) or `:noh`. VSCode mode keeps
  `hlsearch` off.
- **`n`/`N` keep the match centred** (standalone only) and open any fold it is in.
- **Match count in the statusline**: lualine shows `[3/7]` while search highlighting is active, so the
  count survives a future `cmdheight=0`.
- **`<C-f>` searches the current file** (standalone, normal and visual mode): snacks' `lines` picker, a
  fuzzy list of the buffer's lines at the bottom with the editor window scrolling to the selected line as
  a live preview; confirming jumps to the match. In visual mode the selection is the starting query.
  It follows the picker conventions (`Ctrl+c`/`q` close, `<leader>fR` resumes, lazy-loaded).
  This replaces Vim's `<C-f>` (page down) in standalone Neovim; `<C-d>` stays for scrolling. VSCode mode
  is unchanged.
- Docs: `AGENTS.md` (options, keymaps, pickers, plugin row), readme TODO ticked.

Out of scope: flash.nvim / jump labels, nvim-hlslens, searching all open buffers (`grep_buffers`),
`cmdheight=0` itself (the "Less clutter" TODO), and any change to `shared.lua` or `vscode.lua`.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `editor-options`: "Search behaviour" changes (persistent highlighting in standalone Neovim, VSCode
  unchanged); adds centred `n`/`N` and the statusline match count.
- `picker`: adds the "search the current file" picker on `<C-f>`.

## Impact

- `lua/config/options.lua` (standalone block: `hlsearch`), `lua/keymaps/regular.lua` (`n`/`N`),
  `lua/plugins/lualine.lua` (`searchcount`), `lua/plugins/snacks.lua` (`<C-f>` keys).
- No new plugins or dependencies; `docs/dependencies.md`, `gates.ps1`, `gates.sh` unchanged.
- `AGENTS.md`, `readme.md`.
