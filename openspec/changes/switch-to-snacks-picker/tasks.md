# Tasks

## 1. Snacks picker replaces Telescope

- [ ] 1.1 In `lua/plugins/snacks.lua`, add `picker` to `opts` with the close keys from design decision 2 (input: `<C-c>` cancel in `i`/`n`, normal `<Esc>` unmapped; list/preview: `<Esc>` unmapped, `<C-c>` cancel), and add `keys` `<leader>ff` files, `<leader>fa` grep, `<leader>fb` buffers, `<leader>fh` help, each with a `desc`. Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`
- [ ] 1.2 Add the spec's `init` with the `vim.ui.select` stub (design decision 6). Verify: `rg -n "ui.select" lua/plugins/snacks.lua` shows it inside `init`, and the build gate is still green (snacks stays unloaded at startup)
- [ ] 1.3 In `lua/lsp/keymaps.lua`, point `<leader>gd/gr/gi/td/ds/ws` at `require("snacks").picker.lsp_*` inside wrapper functions; `ws` uses `lsp_workspace_symbols` (design decision 5). Verify: `rg -n telescope lua/lsp` returns nothing
- [ ] 1.4 In `lua/plugins/opencode.lua`, set `preferred_picker = "snacks"` and replace the Telescope dependency with `folke/snacks.nvim` (design decision 7). Verify: `rg -n telescope lua` returns nothing
- [ ] 1.5 Delete `lua/plugins/telescope.lua`, run `nvim --headless "+Lazy! clean" +qa`, and remove the `telescope.nvim` and `plenary.nvim` lines from `lazy-lock.json` by hand. No `:Lazy sync` (design decision 8). Verify: `git diff lazy-lock.json` shows only those two lines removed
- [ ] 1.6 Docs: in `AGENTS.md`, replace the Telescope keymap section with a "Pickers" section (the four keys plus the close keys `Ctrl+c`/`q`, and that `<Esc>` doesn't close), change the LSP table's "Telescope:" labels, the plugin table (drop telescope/plenary, update the snacks row), the directory tree, the line-11 summary, and the "Plugin-specific keymaps (e.g., Telescope)" line. In `docs/dependencies.md`, ripgrep's "Why" → snacks picker files/grep. Verify: `rg -n -i telescope AGENTS.md docs` returns nothing, and `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 2. More find keys

- [ ] 2.1 Add `keys` `<leader>fr` recent, `<leader>fw` grep_word (modes `n` and `x`), `<leader>fd` diagnostics, `<leader>fg` git_status, `<leader>fR` resume and `<leader>fP` projects, each with a `desc` (design decision 9). Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`
- [ ] 2.2 Docs: add the six keys to the `AGENTS.md` Pickers section, including that `<leader>fP` changes the cwd (global) and opens the file picker. Tick the readme TODO "open recent projects". Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 3. Command palette

- [ ] 3.1 Add `<leader>fp` opening `Snacks.picker.pick` with `multi` = keymaps (normal mode only) + commands, titled "Command Palette" (design decision 3). Check in the snacks source that `multi` items confirm with their own source's action; if not, add the dispatching `confirm` from decision 3 and note it in a devlog note. Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`
- [ ] 3.2 Add `<leader>fk` keymaps and `<leader>fc` commands, each with a `desc` (design decision 4). Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`
- [ ] 3.3 Docs: add `<leader>fp`/`fk`/`fc` to the `AGENTS.md` Pickers section, noting that only mappings with a `desc` can be found by name. Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 4. Human verification

- [ ] 4.1 User checks in real Neovim, following a recipe the agent provides:
  - `<leader>ff`, `<leader>fa`, `<leader>fb`, `<leader>fh` work as before.
  - `<leader>fr`, `<leader>fw` (on a word, and on a visual selection), `<leader>fd`, `<leader>fg`, and `<leader>fR` after closing a picker with a query.
  - `<leader>fP` lists repos; picking one changes cwd, the accent bar follows, and the file picker opens.
  - `<leader>fp`: `terminal toggle` runs `<leader>tt`; `Lazy` opens `:Lazy`; an LSP mapping runs in an LSP buffer. `<leader>fk` and `<leader>fc` list and run entries.
  - Closing: `Ctrl+c` while typing closes; `<Esc>` while typing goes to normal mode and a second `<Esc>` does nothing; `q` and `Ctrl+c` in normal mode close.
  - `<leader>ca` as the first picker after startup opens the snacks picker; `Ctrl+c` closes it without applying.
  - LSP `<leader>gd/gr/gi/td/ds/ws` in a Lua and a C# buffer.
  - opencode `<leader>os` (select session) uses the snacks picker.
  - Inside VSCode, `<leader>ff` and `<leader>fa` still do the VSCode actions.

## Workflow follow-up

- Build this only after `add-snacks-terminal` is verified and archived (both touch `lua/plugins/snacks.lua` and `AGENTS.md`).
