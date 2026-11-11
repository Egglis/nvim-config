# Design

## Context

See proposal.md (Why). What the research found, on Neovim 0.12.6 with the pinned plugins:

- `lua/config/options.lua` sets `hlsearch = false`, `incsearch`, `ignorecase`, `smartcase` in the shared
  part (both environments). `shortmess` has no `S`, so the `[n/m]` count already shows in the command line
  after `/`, `n`, `N`. `<Esc>` → `:noh` is mapped in `shared.lua` (both environments).
- Visual `*`/`#` (search for the selection) are built in since 0.10.
- snacks (`882c996`) ships a `lines` source: non-live fuzzy matching over the current buffer's lines,
  layout `ivy` (list at the bottom) with `preview = "main"` (the editor window itself scrolls to the
  selected line), `jump = { match = true }` (the cursor lands on the match, not column 1), and on show
  the list starts at the cursor's line. `pattern` sets the starting filter; `picker:word()` returns the
  visual selection captured when the picker opened.
- lualine ships a `searchcount` component: empty when `v:hlsearch == 0`, else `[cur/total]` from
  `searchcount()` (maxcount 999, timeout 500 ms).
- Alternatives looked at: **flash.nvim** labels matches so you jump with 1–2 keys, and can hook into `/`.
  It is a different feature (on-screen jumping), and its usual `s` key takes over Vim's `s`.
  **nvim-hlslens** puts `[n/m]` virtual text next to each match. It mostly duplicates the statusline
  count, and the plugin is older and less maintained. **`grep_buffers`** searches every open buffer
  rather than the current file. The user left all three out (they could become later TODOs).

## Goals / Non-Goals

**Goals:**
- After a search you can see every match, step through them comfortably, and see where you are.
- You can see every matching line at once and jump to one, like Periscope's current-file search.

**Non-Goals:**
- Changing `/` itself (no plugin in the command line, no fuzzy `/`).
- Any VSCode-mode behaviour change.

## Decisions

1. **`hlsearch = true` in the standalone block of `options.lua`; the shared line stays `false`.** VSCode
   mode is unchanged, which the spec requires. The `<Esc>` → `:noh` mapping in `shared.lua` already
   clears it, so `shared.lua` is untouched. Rejected: auto-clearing when the cursor moves away from a
   match. The user chose persistent highlighting.
2. **`n`/`N` → `nzzzv`/`Nzzzv` in `lua/keymaps/regular.lua`, normal mode, `desc` set.** A count still
   applies, because it reaches the first `n` of the right-hand side. `zv` opens a fold containing the
   match. Not in `shared.lua`, which the user keeps as written. Not in visual mode: the plain `n` there
   is fine, and `zz` while extending a selection is jumpy.
3. **lualine: `"searchcount"` first in `lualine_x`.** Built in, so nothing to maintain. lualine's
   refresh timer picks up `:noh` (no event fires for it). It goes ahead of `encoding`/`fileformat`, so the
   "Less clutter" TODO can drop those later without touching it.
4. **`<C-f>` as two lazy `keys` entries in `plugins/snacks.lua`**, next to the other picker keys, so
   snacks still loads on demand:
   - `n`: `Snacks.picker.lines()`.
   - `x`: `Snacks.picker.lines({ pattern = function(picker) return picker:word() end })`. snacks captures
     the selection when the picker opens and leaves visual mode. A single key for both modes isn't
     possible: `word()` falls back to `<cword>` in normal mode, which would pre-fill a query the user
     didn't ask for.
   - The source's own layout is kept (ivy plus the main window as preview), even though the other
     pickers are centred floats: seeing the real file move is the point. The global `<C-c>`/`q`/`<Esc>`
     keys apply because they're set on `picker.win`.
   - Rejected: `<leader>/` or `<leader>fl` (the user chose `<C-f>`), and swapping `<leader>ff` to match
     VSCode, which would break the find-files habit and the spec.
5. **The selection is passed as-is as the fuzzy query.** snacks' matcher scores exact substrings highest,
   so the lines containing the selection come first. Spaces split the query into terms and `^ $ ! '` are
   operators. That's acceptable for the identifiers this is used for.

## Risks / Trade-offs

- [`<C-f>` no longer pages down in standalone Neovim] → `<C-d>`/`<C-u>` (centred) are the scroll keys
  already in use. Insert, command-line and terminal `<C-f>` are untouched. Inside pickers, `<C-f>` still
  scrolls the preview (picker-buffer keys win).
- [Persistent highlight can be noisy after a broad search such as `/e`] → `<Esc>` clears it; that's the
  behaviour the user asked for.
- [`searchcount()` in a huge file] → lualine caps it at 999 matches and 500 ms, and it only runs while
  `v:hlsearch` is set.
- [The `lines` picker in a non-file buffer, e.g. a terminal in normal mode] → it lists that buffer's lines;
  harmless.

## Open Questions

None.
