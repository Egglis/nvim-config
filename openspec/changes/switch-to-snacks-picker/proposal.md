# Proposal

## Why

The user wants a VSCode-style command palette in standalone Neovim, and a wider, consistent set of
"find" pickers. snacks.nvim is already installed (for the terminal), and its picker covers everything
Telescope does today plus a palette, recent files and projects. Switching removes two plugins
(Telescope, plenary) instead of adding more. The user also wants pickers to close on `Ctrl+c`, not on
`<Esc>`.

## What Changes

- **BREAKING (UI only):** Telescope and plenary are removed. Every picker runs on the snacks picker.
  The keys stay the same: `<leader>ff` files, `<leader>fa` live grep, `<leader>fb` buffers,
  `<leader>fh` help, and the LSP list keys `<leader>gd/gr/gi/td/ds/ws`.
- New find keys in standalone Neovim:
  - `<leader>fp`: **command palette**, one list of every named key mapping (by its description) and
    every `:` command; picking an entry runs it.
  - `<leader>fk`: key mappings.
  - `<leader>fc`: `:` commands.
  - `<leader>fr`: recent files.
  - `<leader>fw`: grep the word under the cursor (or the visual selection).
  - `<leader>fd`: diagnostics.
  - `<leader>fg`: git status (changed files).
  - `<leader>fP`: recent projects. Picking one changes Neovim's cwd to it and opens the file picker
    there (readme TODO "open recent projects").
  - `<leader>fR`: resume the last picker with its query.
- **Closing a picker:** `Ctrl+c` closes it from typing and from normal mode, and `q` closes it from normal
  mode. `<Esc>` never closes it: while typing, it switches to normal mode so you can move through the
  list with `j`/`k`.
- `vim.ui.select` lists (code actions, opencode prompts) use the snacks picker too, with the same closing
  keys.
- opencode.nvim's picker setting moves from Telescope to snacks.
- Docs: `AGENTS.md` (picker keymap section replacing the Telescope one, LSP table, plugin table,
  directory tree), `docs/dependencies.md` (ripgrep's "Why"), readme TODO for recent projects.

Out of scope: the file explorer/tree, lazygit, other snacks modules (dashboard, notifier, …), any
change to `lua/keymaps/vscode.lua` or `lua/keymaps/shared.lua`, and a `Ctrl+Shift+P` binding (Windows
Terminal takes that key).

Depends on `add-snacks-terminal`, which adds `lua/plugins/snacks.lua`. Build this after that change is
archived.

## Capabilities

### New Capabilities
- `picker`: fuzzy pickers in standalone Neovim, covering the find keys, the command palette, recent
  projects, how a picker is closed, and that pickers load on demand and stay out of VSCode mode.

### Modified Capabilities
- `keymaps`: the "Standalone search pickers" requirement moves to the new `picker` capability, which
  extends it.

## Impact

- Changed: `lua/plugins/snacks.lua` (picker module, keys, close keys, `vim.ui.select`),
  `lua/lsp/keymaps.lua` (LSP list keys call the snacks picker), `lua/plugins/opencode.lua`
  (`preferred_picker`, dependency list).
- Removed: `lua/plugins/telescope.lua`; `telescope.nvim` and `plenary.nvim` leave `lazy-lock.json`.
- No new external tool: ripgrep is already in `docs/dependencies.md` and checked by `gates.ps1 deps`.
- Docs: `AGENTS.md`, `docs/dependencies.md`, `readme.md`.
