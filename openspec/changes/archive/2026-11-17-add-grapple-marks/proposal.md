# Proposal

## Why

The readme TODO "Show open buffers" is open. Buffers are hard to navigate and to remember: every file
visited through a picker, go-to-definition or the explorer stays listed, so `<leader>fb` fills up with
files the user doesn't care about. The user doesn't want tabs or a buffer bar. In VSCode they already
use vscode-harpoon on `<leader>ha/hh/he/h1–9`, a short hand-picked list of files with fixed numbers.

Research (see design.md) compared Harpoon 2, grapple.nvim and arrow.nvim, plus a buffer bar, a quicker
buffer switcher and auto-closing old buffers. The user chose **only the marks list, using grapple.nvim**.
Nothing else from the research is part of this change.

## What Changes

- **New plugin `cbochs/grapple.nvim`** (standalone only), one list of marked files per project (the
  git root of Neovim's cwd, else the cwd), saved across restarts. No icons (no icon plugin).
- **The same keys as the VSCode harpoon setup**, standalone only:
  - `<leader>ha` toggles a mark on the current file, with a notification ("Marked 3", "Unmarked").
  - `<leader>hh` opens a searchable snacks picker of the marked files, numbered in list order, with a
    preview; `<CR>` opens one.
  - `<leader>he` opens grapple's own window: jump with `<CR>` or `1`–`9`, and edit the list as text
    (`dd` removes, moving a line reorders).
  - `<leader>h1`–`<leader>h9` jump to mark 1–9.
- which-key gets an `h` group name ("marks").
- The buffer picker `<leader>fb` is unchanged; it already closes buffers (`<C-x>` while typing, `dd` in
  normal mode, `<Tab>` to select several). The docs say so.
- Docs: `AGENTS.md` (Marks section, plugin row, which-key group list), readme TODO reworded and ticked.

Out of scope (the user's call): marks or buffers in the top bar or statusline, a new buffer switcher
key, auto-closing old buffers, snipe.nvim, any change to `shared.lua` or `vscode.lua`.

## Capabilities

### New Capabilities

- `file-marks`: a short, per-project, persistent list of marked files with fixed numbers, and the
  `<leader>h…` keys to mark, list, edit and jump to them in standalone Neovim.

### Modified Capabilities

None. The picker spec's general rules (closing, on-demand loading, absent in VSCode) apply to the new
`<leader>hh` picker as written, and the key-hints group scenario lists groups with "including".

## Impact

- New `lua/plugins/grapple.lua` (spec, lazy on its keys and `:Grapple`).
- `lua/plugins/snacks.lua`: a `grapple` picker source for `<leader>hh` (the key itself lives in
  `grapple.lua`, which loads snacks on demand like the other picker keys do).
- `lua/plugins/which-key.lua`: `h` group.
- `lazy-lock.json` gains grapple. No new external tool: `docs/dependencies.md`, `gates.ps1`, `gates.sh`
  unchanged.
- `AGENTS.md`, `readme.md`.
