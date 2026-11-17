# Tasks

## 1. Recording indicator

- [x] 1.1 `lua/plugins/lualine.lua`: a recording component right after `mode` in `lualine_a` (`REC @<reg>` while `reg_recording()` is set, empty otherwise, loud fixed colour), plus a `RecordingEnter`/`RecordingLeave` autocmd calling `require("lualine").refresh()` (scheduled on leave) (design decision 1). Verify headless: after feeding `qa` the evaluated statusline contains `REC @a` immediately (no timer wait); after `q` it doesn't; the built-in check `qq A;<Esc>j q` then `3Q` on five lines ends four lines with `;` (spec "Default macro keys are unchanged"); linewise `V` + `Q` runs per line
- [x] 1.2 Docs: `AGENTS.md` new "Macros" section (built-in flow: `qq … q`, `Q`/count, `@@`, visual `Q`/`@q`, `:reg`) with the indicator; readme TODO not ticked yet. Verify: `./gates.sh gates` → `GATES_EXIT:0`

## 2. Register list on `@` (dropped)

- [x] 2.1 Tried `{ "@", mode = "n", plugin = "registers" }` in `lua/plugins/which-key.lua`; quick `@q @@ @@ @@` (~150 ms apart) edited the wrong lines, so it was reverted at the user's call (design decision 2). Verify: `git diff 4e73ddb -- lua/plugins/which-key.lua` is empty; the measurements are in the devlog
- [x] 2.2 Planning artifacts follow the decision: proposal, the spec ("Default macro keys are unchanged" covers `@` and quick repeats; the popup requirement removed), design decision 2 and Risks, tasks §3/§4. Verify: `./gates.sh gates` → `GATES_EXIT:0`

## 3. Macro picker and editor

- [ ] 3.1 `lua/config/macros.lua`: `list()` (registers `a`–`z`, non-empty, readable via `keytrans`), `run(reg)` (feeds `@reg` with a non-remapped `@`), `edit(reg)` (float, `buftype=acwrite`, name `macro://<reg>`, `BufWriteCmd` → `setreg(reg, keycode(text))`, `q`/`<Esc>` close) (design decisions 3–4). No plugin require at load time. Verify headless: `list()` shows `q` as `A;<Esc>` and skips empty `b`; `edit("q")`, set the line to `A,<Esc>j`, `:w` → `getreg("q") == "A,\27j"` and `@q` works; editing then closing without `:w` leaves it unchanged; a literal `<` survives the round trip
- [ ] 3.2 `lua/plugins/snacks.lua`: `opts.picker.sources.macros` (finder from `macros.list()`, `register` format, preview, shared centred layout, confirm → close + scheduled `macros.run`, `<C-e>` action → `macros.edit`) and a lazy `<leader>fm` key with `desc` (design decision 3). Verify headless: snacks not loaded after a start with a file argument; `<leader>fm` opens source `macros` listing only non-empty `a`–`z`; confirming `q` runs it once in the original window (current win unchanged, buffer changed as expected); a macro using a user mapping behaves as with a typed `@q`; `<C-e>` opens the editor float; no registers → no error; with which-key loaded `maparg("@","n")` is empty and `@q` then `@@` ×3 sent ~150 ms apart edits four lines in a row (spec "Quick repeats"), `3@q` runs three times; `vim.g.vscode` start: `maparg("<leader>fm","n")` empty; every config mapping has a `desc`
- [ ] 3.3 Docs: `AGENTS.md` Macros section (picker, editor), Pickers table row `<leader>fm`, snacks plugin row lazy keys; `readme.md` "Easier macros" TODO ticked with a one-line summary. Verify: `./gates.sh gates` → `GATES_EXIT:0`

## 4. Human check

- [ ] 4.1 **Human check**, following a recipe the agent provides: in a real file, `qq` shows the `REC @q` block (colour OK next to the repo accent?) and it disappears on `q`; `Q`, `3Q`, visual-line `Q`; `@q` then `@@` typed quickly; `<leader>fm` lists macros readably, `<CR>` runs one, `<C-e>` edits and `:w` saves; VSCode with vscode-neovim: `qq`/`@q`/`Q` unchanged. Verify: the user's answers recorded in a devlog note

## Workflow follow-up

- Whole-change review, change-done note, offer an independent review, then offer `/opsx-archive`.
