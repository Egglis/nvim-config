# Tasks

## 1. File tree

- [ ] 1.1 In `lua/plugins/snacks.lua` (design decisions 2–4): a `<leader>fe` entry in `keys` calling `Snacks.explorer()` with a `desc`, and `opts.picker.sources.explorer = { layout = { layout = { position = "right" } }, win = { list = { keys = { ["<c-c>"] = "cancel", ["<c-t>"] = false } } } }`. No `opts.explorer`. Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0` and `pwsh ./gates.ps1 format` → `FORMAT_EXIT:0`
- [ ] 1.2 Headless checks in a throwaway script under `$env:TEMP\opencode\` (design decision 6), with a file of this repo open (e.g. `lua/config/options.lua`): `Snacks.explorer()` opens a picker with source `explorer` whose list window is right of the editor window (its column is larger); the cursor is in the list on `options.lua` (follow file); in the list buffer `maparg("<C-C>", "n", false, true)` is buffer-local and closes the tree, there's no buffer-local `<C-T>` (so the global terminal toggle applies), and `<Esc>` isn't buffer-mapped to close; feeding `<C-c>` closes the tree and `getcwd()` is unchanged; a second `Snacks.explorer()` closes an open tree; `Snacks.explorer.config.trash == true` without `opts.explorer` (else apply design decision 4's fallback and note why); `:messages` empty at startup; with `--cmd "let g:vscode=1"`, snacks isn't loaded. Verify: the script's output quoted in a devlog note
- [ ] 1.3 Docs: `AGENTS.md`, with a "File explorer" section (key, right sidebar, stays open, keys `a` with `/` for folders, `r`/`m`/`c`/`d` (Recycle Bin)/`y`/`p`/`P`/`H`/`I`/`<BS>`, `Ctrl+c`/`q` close, `<C-t>` is the terminal toggle), the snacks plugin row (explorer, `<leader>fe`), the note on keys that mean different things in the two environments (`<leader>fe` toggles here, focuses in VSCode), and the directory tree comment for `snacks.lua`; `readme.md`: tick the file treeview TODO. Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 2. Human check

- [ ] 2.1 **Stop for the user** with a recipe: `<leader>fe` opens the tree on the right and toggles it closed; opening a file keeps it open; `a` → `test.md` and `a` → `testdir/` create a file and a folder; `r` renames; `d` asks, then the file is in the Recycle Bin; `P` previews while moving; a changed file shows a git mark; `Ctrl+c` and `q` close it, `<Esc>` doesn't; `<C-t>` toggles the terminal from the tree; in VSCode `<leader>fe` still focuses VSCode's explorer. Verify: the user's answers recorded in the devlog; any failure becomes a fix section agreed with the user

## Workflow follow-up

- Whole-change review, change-done note, offer an independent review, then offer `/opsx-archive`.
