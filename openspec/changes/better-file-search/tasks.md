# Tasks

## 1. Built-in search polish

- [x] 1.1 `lua/config/options.lua`: `opt.hlsearch = true` in the standalone block, shared line unchanged (design decision 1). Verify headless (`nvim --headless`): `vim.o.hlsearch` is true; with `--cmd "let g:vscode=1"` it is false
- [x] 1.2 `lua/keymaps/regular.lua`: `n` → `nzzzv`, `N` → `Nzzzv` (normal mode, with `desc`) (design decision 2). Verify headless on a generated 500-line buffer with `foo` every 50 lines: after `/foo<CR>` then `n`, the cursor is on the next match and `winline()` is about `winheight(0)/2`; `3n` skips three matches; a match inside a closed fold is opened (`foldclosed('.') == -1`)
- [x] 1.3 `lua/plugins/lualine.lua`: `"searchcount"` first in `lualine_x` (design decision 3). Verify headless: after `/foo<CR>` on the 3rd of 7 matches, `require("lualine").statusline()` (or the evaluated `&statusline`) contains `[3/7]`; after `:noh` it doesn't
- [x] 1.4 Docs: `AGENTS.md` Options section (`hlsearch` standalone on, VSCode off), regular keymaps table (`n`/`N`), and a note on the statusline count. Verify: `./gates.sh gates` → `GATES_EXIT:0`

## 2. Search the current file picker

- [ ] 2.1 `lua/plugins/snacks.lua`: `<C-f>` lazy keys, `n` → `Snacks.picker.lines()`, `x` → `lines` with `pattern` = `picker:word()`, each with `desc` (design decision 4). Verify headless: snacks is not loaded after a start with a file argument (picker spec on-demand rule); `<C-f>` in a file opens a picker with source `lines`; in visual mode on `attach_lualine` the picker's filter pattern is `attach_lualine` and its items include the line(s) containing it; confirming an item puts the cursor on the match in the original window; with `--cmd "let g:vscode=1"` `maparg("<C-f>", "n")` is empty; every config mapping still has a `desc`
- [ ] 2.2 Docs: `AGENTS.md` Pickers table (`<C-f>`, both modes, live preview in the editor window, replaces page-down) and the snacks plugin row's lazy-key list; `readme.md` TODO "Better search in the current file" ticked with a one-line summary. Verify: `./gates.sh gates` → `GATES_EXIT:0`

## 3. Human check

- [ ] 3.1 **Human check**, following a recipe the agent provides: in a real C# and Lua file, `/` + `n`/`N` (highlight stays, line centred, `[x/y]` in the statusline, `<Esc>` clears all three); `<C-f>` in normal and visual mode (list at the bottom, file scrolls as you move, `<CR>` jumps, `Ctrl+c` returns to the old spot, `<leader>fR` resumes); VSCode with vscode-neovim: `/` has no lingering highlight and `<C-f>` behaves as before. Verify: the user's answers recorded in a devlog note

## Workflow follow-up

- Whole-change review, change-done note, offer an independent review, then offer `/opsx-archive`.
