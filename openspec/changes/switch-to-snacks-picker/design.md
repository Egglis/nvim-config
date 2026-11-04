# Design

## Context

See proposal.md (Why). After `add-snacks-terminal`, `lua/plugins/snacks.lua` holds snacks with
`opts = { terminal = {} }`, lazy-loaded on its `keys`; the `terminal` spec forbids loading snacks at
startup. Telescope is set up eagerly in `lua/plugins/telescope.lua` (no lazy trigger), and
`lua/lsp/keymaps.lua` requires `telescope.builtin` inside its `LspAttach` callback. opencode.nvim lists
Telescope as a dependency and sets `preferred_picker = "telescope"`. Nothing else uses plenary.

Snacks picker facts, from the installed source (`882c996`):
- Sources exist for everything we need: `files`, `grep`, `buffers`, `help`, `recent`, `grep_word`,
  `diagnostics`, `git_status`, `resume`, `keymaps`, `commands`, `projects`, `select`, and the
  `lsp_*` lists.
- The input window maps insert `<C-c>` to cancel and normal `<Esc>` to cancel; the list and preview
  windows map `<Esc>` and `q` to cancel. Insert `<Esc>` falls through to Vim (leaves insert mode).
- `keymaps` runs an entry with `nvim_input(lhs)`; `commands` runs it as `:cmd`.
- A picker can merge sources with `multi = { ... }`.
- `projects` lists project roots of recent files plus `~/dev` and `~/projects`. Confirm (`load_session`)
  does a global `chdir`, then opens the `files` picker, since no session plugin is installed.
- `picker.ui_select = true` (default) replaces `vim.ui.select` when snacks sets up.

## Goals / Non-Goals

**Goals:** one picker plugin for everything; same keys as today; the palette; `Ctrl+c` to close; no
startup cost.

**Non-Goals:** custom layouts or theming (snacks defaults); the explorer; frecency tuning; changing
`~/dev`/`~/projects` as project roots.

## Decisions

1. **Everything lives in `lua/plugins/snacks.lua`**, next to the terminal: `opts.picker = { ... }`
   and the find keys in the spec's `keys` list, so lazy.nvim still loads snacks on first use.
   *Alternative:* a separate `picker.lua` spec for the same plugin. lazy.nvim merges specs, but split
   `opts` and `keys` for one plugin are harder to follow.
2. **Close keys are set once in `opts.picker.win`** so every picker (including `vim.ui.select` and
   opencode's) gets them:
   - input: `<C-c>` → cancel in `i` and `n`; normal `<Esc>` → `false` (unmapped), so it does nothing.
     Insert `<Esc>` keeps Vim's behaviour (to normal mode).
   - list and preview: `<Esc>` → `false`, `<C-c>` → cancel; `q` stays cancel.
3. **Palette = `Snacks.picker.pick({ multi = { keymaps, commands } })`**, with the keymaps part limited
   to normal mode (`modes = { "n" }`), mappings with a description, and buffer-local ones included. A
   title "Command Palette".
   *To check during implementation:* that each item in a `multi` picker confirms with its own source's
   action. If not, give the palette one `confirm` that runs `nvim_input(item.item.lhs)` for keymap items
   and `:cmd` for command items.
   Mappings without a `desc` (`shared.lua`, `vscode.lua`, some built-ins) still show up by their key,
   but they can't be found by name. This is accepted; those files stay as the user wrote them.
4. **`<leader>fk`/`<leader>fc` are the plain `keymaps`/`commands` sources** (all modes for keymaps).
5. **LSP list keys call `require("snacks").picker.lsp_*()` inside wrapper functions** in
   `lua/lsp/keymaps.lua`. lazy.nvim loads snacks on the first `require`, which keeps the rule that
   modules outside `plugins/` never require a plugin at load time. `lsp_dynamic_workspace_symbols`
   becomes `lsp_workspace_symbols` (live search in snacks).
6. **`vim.ui.select` before load:** the spec's `init` (runs at startup without loading the plugin) sets
   `vim.ui.select` to a stub that calls `require("snacks").picker.select(...)`. On load, snacks'
   `ui_select` replaces the stub with its own. This makes code actions use the picker even if no find
   key was pressed first, without loading snacks at startup.
   *Alternative:* `ui_select = false` (always native). Rejected: the native list closes on `<Esc>`, and
   the user wants one consistent picker.
7. **opencode.nvim:** `preferred_picker = "snacks"`; replace the Telescope dependency with
   `folke/snacks.nvim`.
8. **Removing Telescope:** delete `lua/plugins/telescope.lua`, run `:Lazy! clean`, and remove the
   `telescope.nvim` and `plenary.nvim` lines from `lazy-lock.json` by hand. Do **not** run `:Lazy sync`;
   it updates every unrelated plugin (seen in `add-snacks-terminal`).
9. **`<leader>fw`** is mapped in `n` and `x`; snacks' `grep_word` uses the visual selection in `x`.

## Risks / Trade-offs

- [Palette runs a mapping with `nvim_input`, so it runs in whatever mode/window is current after the
  picker closes] → The picker closes first and returns to the previous window, which is where the user
  pressed `<leader>fp`. Check with `<leader>tt` and an LSP key.
- [The project list is only as good as `oldfiles` plus `~/dev`/`~/projects`] → Repos opened at least
  once show up. Extra roots can be added to `projects.dev` later without spec changes.
- [`chdir` on project switch is global, not tab-local] → It fires `DirChanged`, so the repo accent
  follows. Terminals and opencode sessions are keyed by cwd, so they switch with it (the terminal
  spec already documents that).
- [Muscle memory: `<Esc>` no longer closes a picker] → The user asked for this. `q` (normal) and
  `Ctrl+c` both close it.
- [snacks picker uses `fd` if installed, else `rg`] → `rg` is a checked dependency; no new tool.

## Migration Plan

Telescope goes in the same change that adds every replacement key, so there is no gap. Rollback =
revert the commits and `:Lazy! restore`.
