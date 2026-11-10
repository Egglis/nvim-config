# Design

## Context

See proposal.md (Why). Facts at the pinned snacks.nvim (`882c996`):

- `Snacks.explorer()` opens the `explorer` picker source. Calling a picker source that is already open
  closes it, so one key toggles the tree.
- Explorer defaults: `layout = { preset = "sidebar", preview = false }` (width 40, an input line on top,
  and the preview shown in the main editor window when toggled), `focus = "list"`, `auto_close = false`,
  `jump = { close = false }`, `follow_file = true`, git status and diagnostics on, and a file watcher.
  snacks' own comment says `layout = { layout = { position = "right" } }` puts it on the right.
- Explorer list keys include `a` add (a trailing `/` makes a folder), `d` delete, `r` rename, `c` copy,
  `m` move, `y`/`p` yank/paste, `P` toggle preview, `o` open with the system app, `H`/`I` hidden/ignored,
  `<BS>` up, `h`/`l` close/open. They also bind `<c-c>` to `tcd` and `<c-t>` to `terminal`.
- Merge order in `snacks.picker.config.get`: defaults, then the user's global `opts.picker`, then the
  source (which already includes the user's `opts.picker.sources.<name>`), then the call's opts. So the
  explorer's own `<c-c>`/`<c-t>` beat the config's global `<C-c> = cancel`. Only an override under
  `opts.picker.sources.explorer` wins. The global `<Esc> = false` survives, because the source sets no
  `<Esc>`.
- Delete asks "Delete …?" and, with `trash = true` (the explorer module's default), uses PowerShell's
  `Microsoft.VisualBasic` `SendToRecycleBin` on Windows.
- netrw replacement (`opts.explorer.replace_netrw`) only runs when the explorer module is set up through
  `opts.explorer`. snacks is lazy when Neovim gets a file or folder (`lazy = vim.fn.argc(-1) > 0`).
- In VSCode mode, `vscode.lua` already maps `<leader>fe` to `workbench.files.action.focusFilesExplorer`.
- The other pickers (e.g. the git ones) use snacks' default layout rule: preset `default` at 120+ columns
  (a centred 80% float: input and list on the left, preview on the right), else `vertical` (stacked).
  Their defaults are `auto_close = true` and close-on-jump.

## Goals / Non-Goals

**Goals:** the `file-explorer` spec with snacks' explorer, configured in `lua/plugins/snacks.lua` only,
keeping the existing picker and terminal keys.

**Non-Goals:** changing snacks' other explorer keys, a custom layout beyond snacks' presets, opening the
tree automatically, and netrw replacement or `nvim .` behaviour.

## Decisions

1. **snacks explorer, no new plugin.** It's already installed and lazy-loaded, and it uses the same
   picker UI and conventions as the rest of the config. *Alternatives:* oil.nvim (edit the folder as a
   buffer; not a tree) and neo-tree (heavier, 3 plugins). The user chose snacks.
2. **`<leader>fe` in the snacks spec's `keys`**, calling `Snacks.explorer()`. It toggles (see Context),
   and as a lazy key it loads snacks on first use. The key matches VSCode's explorer key. *Alternative:*
   `<leader>e`; the user chose `<leader>fe`.
3. **Source options in `opts.picker.sources.explorer`** (revised after §1, see below):
   - `layout = { preset = <columns >= 120 and "default" or "vertical">, preview = true }`: the same
     centred float as the git pickers, with the preview on when it opens (the user's choice).
   - `jump = { close = true }` and `auto_close = true`: opening a file closes the float, and moving out of
     it closes it, like every other picker. A float left open would cover the file just opened.
   - `win.list.keys`: `["<c-c>"] = "cancel"`, so Ctrl+c closes it like every other picker (picker spec)
     instead of `tcd`; `["<c-t>"] = false`, so the buffer-local `terminal` action is removed and the
     global `<C-t>` terminal toggle applies (terminal spec).
   - Everything else stays at snacks' defaults: follows the current file, git and diagnostics on, trash
     on delete.
   - *Revision:* §1 built `layout = { layout = { position = "right" } }`, a 40-column right sidebar that
     stayed open on file open. After trying it the user chose the float with the preview on, and
     opening a file closing it.
7. **Sidebar on `<leader>fE`** (added after the §3 check; the user prefers the float but wants the
   sidebar available): a second `keys` entry calling `Snacks.explorer()` with call-level opts, which
   merge last and so beat `opts.picker.sources.explorer`: `layout = { preset = "sidebar", preview =
   "main", layout = { position = "right" } }`, `jump = { close = false }`, `auto_close = false`. The key
   overrides in the source apply to both. `preview = "main"` is snacks' sidebar mode (the preview takes
   the editor window; with `auto_close = false` snacks hides it when you leave the tree and brings it
   back when you return). Right side as in §1, preview on (the user's choices). *Alternatives:* a config
   switch or a runtime style toggle for `<leader>fe`; the user chose a second key. Both keys open the
   same `explorer` source, so either one closes whichever tree is open.
4. **No `opts.explorer`**, so netrw replacement stays off and `nvim .` opens as before. The explorer
   module's defaults (including `trash = true`) apply when the picker uses it. Verify in §1 that delete
   really uses the Recycle Bin without `opts.explorer`. If it doesn't, set `opts.explorer =
   { replace_netrw = false }` (`trash` defaults to true there), and record the reason.
5. **No icon plugin.** snacks falls back to its own file and folder glyphs, which the start screen
   already uses (the terminal font has the Nerd Font glyphs). The user chose plain.
6. **Tests:** headless checks for what can be checked without a UI: that the tree opens as a float with
   the preview showing the file under the cursor, `P` toggles the preview, `<CR>` on a file opens it
   and closes the tree while `<CR>` on a folder keeps it, the list buffer's keys (`<c-c>` → cancel, no
   buffer-local `<c-t>`, `<Esc>` not mapped to close), toggle-closes, follows the current file, the cwd
   is unchanged after `<c-c>`, a startup with no messages, and VSCode mode. Create, rename and delete go
   to a human check with a recipe: they prompt through snacks' input and confirm windows, and the
   Recycle Bin can't be checked headless.

## Risks / Trade-offs

- [The float covers the editor] → It closes on opening a file and on leaving it, like the other
  pickers; `<leader>fe` reopens it at the current file.
- [`<leader>fe` toggles here but only focuses in VSCode] → Documented in AGENTS.md's note on keys that
  mean different things in the two environments.
- [A snacks update changes the explorer's default keys] → The overrides are only for `<c-c>`/`<c-t>`.
  The headless key check catches a change there when the plugin is updated.
- [Deleting is a Recycle Bin move, not permanent] → Intended. If no trash command works, snacks deletes
  permanently, and its health check warns about that. The human check confirms the Recycle Bin.
