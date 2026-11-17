# Design

## Context

See proposal.md (Why). The current state, checked on Neovim 0.12 with the pinned plugins:

- **Buffers:** `<leader>fb` is `Snacks.picker.buffers()` with snacks' defaults: most recently used first,
  current buffer included, `<C-x>` (input) / `dd` (list) run `bufdelete` on the selected items (`<Tab>`
  selects several). `<M-q>` is `:b#`; `<leader>bd`/`<leader>bo` close buffers. The top bar
  (`repo_accent.lua`) shows only the repo name.
- **`<leader>h…`** is unused in standalone Neovim. `vscode.lua` maps `<leader>ha` (add),
  `<leader>hh` (quick pick), `<leader>he` (edit list) and `<leader>h1`–`h9` to vscode-harpoon. That file
  is left as the user wrote it.
- **grapple.nvim** (`cbochs/grapple.nvim`, needs Neovim ≥ 0.10): tags on file paths, per scope, saved as
  JSON under `stdpath("data")/grapple`, loaded on demand. Default scope `git` = `vim.fs.find(".git",
  { upward = true })` from the **cwd**, falling back to `cwd`. API: `toggle`, `exists`, `select({ index })`,
  `tags()` (list of `{ path, name?, cursor }`), `toggle_tags()` (its window: `<CR>`, `1`–`9` quick
  select, edit as text, `q`/`<Esc>` close and apply). `toggle`/`select` report errors through
  `vim.notify` but say nothing on success. `icons = true` by default needs nvim-web-devicons.
- **Alternatives looked at:** Harpoon 2 (closest to VSCode, but still on the unmerged `harpoon2`
  branch with slow upkeep), arrow.nvim (one-key menu, doesn't fit `h1–9`). The user chose grapple.

## Goals / Non-Goals

**Goals:**
- `<leader>h…` in standalone Neovim does what it does in VSCode, on grapple.
- The `<leader>hh` list looks and behaves like the other pickers.

**Non-Goals:**
- Showing marks or buffers anywhere on screen; a new buffer switcher; closing buffers automatically.
- Touching `shared.lua`, `vscode.lua` or `<leader>fb`.

## Decisions

1. **New spec file `lua/plugins/grapple.lua`, lazy on `keys` + `cmd = "Grapple"`.** Options:
   a custom scope `project` (resolver: `vim.fs.root(cwd, ".git")`, else the cwd; cached until
   `DirChanged`), `icons = false` (no icon plugin in this config), `status = true`,
   `style = "basename"` (file name first with a dim folder hint, easier to scan than relative paths),
   `win_opts.border = "rounded"` to match the snacks floats. Every key has a `desc`.
   - Changed in §1: grapple's built-in `git` scope resolves from the cwd but is cached until
     `BufEnter`/`FocusGained`, so right after `:cd` to another repo the keys still used the old list
     (headless check). The custom scope is cached on `DirChanged` instead, so `:cd` switches at once.
   - Rejected: `git_branch` scope (a list that disappears when switching branches is surprising),
     `event = "BufReadPost"` loading (nothing needs grapple before a key is pressed).
2. **`<leader>ha` = toggle with a notification.** A small function: if the buffer has no file
   (`buftype ~= ""` or empty name) → do nothing (optionally a short info). Else
   `exists()` before → `toggle()` → notify "Unmarked <name>" or "Marked <n>: <name>" (index from
   `find()`/`tags()` after the toggle). Uses `vim.notify` with a `title = "Marks"`, like the other
   notifications.
   - Rejected: add-only like vscode-harpoon (user chose toggle).
3. **`<leader>h1`–`h9` = `select({ index = n })`**, generated in a loop in the spec's `keys`. A missing
   index is checked first (`find({ index = n })`) and reported as "No mark n" at `INFO` level instead of
   grapple's raw error.
4. **`<leader>hh` = a custom snacks source `marks`** in `opts.picker.sources` (next to `macros`):
   - `finder`: `require("grapple").tags()` mapped to items `{ text = "<n> <relative path>", file = path,
     pos = { cursor[1], cursor[2] } }`, in list order; `format = "file"` with the index shown first,
     `preview = "file"`, layout = the shared `centred_layout()` rule with preview. Confirm = snacks' default
     `jump` (opens the file at the saved cursor).
   - Sorting keeps list order when the query is empty (`sort = { fields = { "idx" } }` or the matcher's
     `keep_order`-style option; whichever snacks supports is confirmed during §1).
   - The key is defined in `grapple.lua` (so pressing it loads grapple), and calls
     `Snacks.picker.pick("marks")`, which loads snacks through lazy.nvim's module loader as other
     cross-plugin calls do. `require("grapple")` happens only inside the finder.
   - Rejected: grapple's own window for both `hh` and `he` (user chose search + window), grapple's
     telescope extension (no telescope here).
5. **`<leader>he` = `toggle_tags()`**, grapple's window, unchanged apart from the border. Its own keys
   apply inside it (`<CR>`, `1`–`9`, `<C-s>`/`|` splits, `R` rename, `-` scopes, `?` help).
6. **which-key:** add `{ "<leader>h", group = "marks" }` to the group list.
7. **Standalone only by placement:** plugin specs never load in VSCode mode, so no `vim.g.vscode` check
   is needed; `vscode.lua` keeps its own `<leader>h…` maps.

## Risks / Trade-offs

- [Grapple's project root comes from the cwd, not the file] → same rule as the repo accent; a
  file opened from another repo is marked in the cwd's list. Accepted, matches "project = cwd's repo".
- [Windows and WSL paths differ (`C:\…` vs `/mnt/c/…`)] → separate lists per platform for the same
  checkout. Accepted; the save files live in each platform's own `stdpath("data")`.
- [Grapple's window `<Esc>` closes it, while pickers ignore `<Esc>`] → it's grapple's own window, not a
  picker; the spec only asks for `q`-style closing via the window. Accepted, noted in AGENTS.md.
- [Grapple upkeep: the last commit on `main` is from Sep 2024] → small, feature-complete plugin pinned in
  `lazy-lock.json`, works on Neovim 0.12 in the headless checks; marks are plain JSON files, so moving
  to another plugin later loses nothing important.
- [Mark numbers shift when a mark is removed] → expected (same as vscode-harpoon); `<leader>he` shows the
  current order.

## Migration Plan

None: new keys on an unused prefix. Rollback = delete `lua/plugins/grapple.lua`, the `marks` source and
the which-key group; the saved lists in `stdpath("data")/grapple` can be deleted by hand.
