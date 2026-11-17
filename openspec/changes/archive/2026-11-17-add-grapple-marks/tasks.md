# Tasks

## 1. Grapple and the mark keys

- [x] 1.1 `lua/plugins/grapple.lua`: `cbochs/grapple.nvim`, lazy on `keys` + `cmd = "Grapple"`, opts: custom `project` scope (git root of the cwd, else cwd, cached on `DirChanged`), `icons = false`, `style = "basename"`, rounded border (design decision 1); `<leader>ha` toggle with "Marked n: name" / "Unmarked name" notifications and a no-op for buffers without a file (decision 2); `<leader>h1`–`h9` via `select({ index })` with "No mark n" for a missing index (decision 3); `<leader>he` → `toggle_tags()` (decision 5); every key has a `desc`. `lazy-lock.json` gains grapple. Verify headless (isolated `stdpath("data")`, a temp git repo): `<leader>ha` on two files gives marks 1–2 with notifications, again on file 1 removes it and the buffer stays listed; `<leader>ha` in a `[No Name]` buffer and a terminal → no mark, no error; `<leader>h2` opens mark 2, `<leader>h5` → "No mark 5" and buffer unchanged; a restart (new headless instance, same data dir) keeps the list; `:cd` to a second temp repo → empty list, back → list again; grapple not loaded after a plain start with a file argument; `vim.g.vscode` start: grapple not loaded and `<leader>ha` is vscode.lua's map
- [x] 1.2 `lua/plugins/which-key.lua`: `{ "<leader>h", group = "marks" }` (decision 6). Verify headless: which-key's spec contains the `h` group; `./gates.sh gates` → `GATES_EXIT:0`

## 2. Searchable mark list

- [x] 2.1 `lua/plugins/snacks.lua`: a `grapple` source (snacks already has a `marks` source) in `opts.picker.sources` (finder from `require("grapple").tags()` inside the function, items numbered in list order with file + saved cursor, file preview, `centred_layout()`, default jump confirm, list order kept with an empty query) and `<leader>hh` in `grapple.lua` calling `require("snacks").picker.pick("grapple")` (decision 4). Confirm which snacks option keeps list order and record it in a devlog note. Verify headless: three marks → `<leader>hh` lists them as 1–3 in order; typing part of the second name filters to it and `<CR>` opens it at its saved cursor; no marks → no error; `<C-c>` closes, `<Esc>` doesn't; snacks still not loaded at a start with a file argument until a key is used
- [x] 2.2 Docs: `AGENTS.md` new "Marks" section (keys, per-project lists in `stdpath("data")/grapple`, grapple window keys, note that `<leader>fb` closes buffers with `<C-x>`/`dd`/`<Tab>`), plugin table row, directory tree entry, which-key group list, snacks row's lazy keys/sources; `readme.md` "Show open buffers" TODO reworded to what was built and ticked (keep the user's own uncommitted readme edits). Verify: `./gates.sh gates` → `GATES_EXIT:0`

## 3. Human check

- [x] 3.1 **Human check**, following a recipe the agent provides: in a real repo, mark three files with `<leader>ha` (notifications readable?), jump with `<leader>h1`–`h3`, `<leader>hh` search + preview feels like the other pickers, `<leader>he` reorder/delete then `<leader>h1`, unmark keeps the buffer, restart keeps the list; `<leader>fb` `<C-x>`/`dd` closes buffers; VSCode with vscode-neovim: `<leader>ha/hh/he/h1` still run vscode-harpoon. Verify: the user's answers recorded in a devlog note

## Workflow follow-up

- Whole-change review, change-done note, offer an independent review, then offer `/opsx-archive`.
