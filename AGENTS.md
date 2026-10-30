# Agent Guide — Neovim Config

This document provides context for AI agents working on this Neovim configuration repository.

---

## Repository Purpose

This is a personal Neovim configuration that supports **two runtime environments**:

1. **Standalone Neovim** — full plugin stack, LSP, completions, telescope, etc.
2. **VSCode via vscode-neovim extension** — minimal mode; no plugins loaded, only keymaps that delegate to VSCode commands.

The same config repo is used for both. The entry point (`init.lua`) branches on `vim.g.vscode` at startup.

---

## Directory Structure

```
nvim/
├── init.lua                        # Entry point — conditional boot logic
├── AGENTS.md                       # This file
├── gates.ps1                       # OpenSpec gate targets (build/format/validate/deps)
├── stylua.toml                     # Lua formatting standard (used by the format gate)
├── docs/dependencies.md            # Required tools, checked by `gates.ps1 deps`
├── openspec/                       # OpenSpec specs and changes
├── .opencode/                      # OpenSpec /opsx-* commands and skills
├── readme.md                       # Minimal readme
├── lazy-lock.json                  # Pinned plugin versions (commit lockfile)
├── nvim.code-workspace             # VSCode workspace for editing this config
├── .vscode/settings.json           # Tells VSCode Lua LSP to recognize `vim` global
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1  # PowerShell profile (aliases, oh-my-posh)
└── lua/
    ├── options/
    │   └── options.lua             # All vim.opt settings
    ├── keymaps/
    │   ├── shared.lua              # Active in BOTH Neovim and VSCode
    │   ├── vscode.lua              # VSCode-only (calls vscode.action())
    │   └── regular.lua             # Standalone Neovim-only
    ├── lazy/
    │   └── init_lazy.lua           # lazy.nvim bootstrap + setup
    ├── plugins/                    # One file per plugin; auto-discovered by lazy.nvim
    │   ├── theme.lua               # tokyonight colorscheme
    │   ├── lualine.lua             # Statusline
    │   ├── telescope.lua           # Fuzzy finder
    │   ├── lsp.lua                 # mason, mason-lspconfig, nvim-lspconfig, fidget, neodev
    │   └── cmp.lua                 # nvim-cmp autocompletion
    ├── lsp_config.lua              # LSP server definitions, on_attach, capabilities
    └── bru/
        └── vscode_keymaps.lua      # LEGACY — not required anywhere, kept for reference
```

---

## Boot Logic (`init.lua`)

```
init.lua
  ├── options/options.lua           (always)
  ├── keymaps/shared.lua            (always)
  ├── if vim.g.vscode:
  │     └── keymaps/vscode.lua
  └── else:
        ├── keymaps/regular.lua
        └── lazy/init_lazy.lua      (loads all plugins)
```

**Plugins are never loaded in VSCode mode.** Do not add plugin requires outside the `else` branch.

---

## Keybinding Architecture

The leader key is `<Space>`.

### Conventions

- Each keymap file **returns a function** — it does not execute on require. `init.lua` calls the returned function.
- `shared.lua` — safe for both environments; no plugin dependencies allowed.
- `vscode.lua` — may use `require('vscode').action(...)` freely.
- `regular.lua` — may use any plugin or Neovim-only API.
- LSP keymaps live in `lsp_config.lua` (buffer-local, set inside `on_attach`).
- Plugin-specific keymaps (e.g., Telescope) live inside the plugin's own spec file in `plugins/`.

---

## Keymaps Reference

### Shared — `lua/keymaps/shared.lua`
Active in both standalone Neovim and VSCode.

| Keys | Mode | Action |
|------|------|--------|
| `<leader>y` | n, v | Yank to system clipboard (`"+y`) |
| `<leader>p` | n, v | Paste from system clipboard (`"+p`) |
| `<` | v | Indent left, keep selection |
| `>` | v | Indent right, keep selection |
| `<C-s>` | n | Save file |
| `<Esc>` | n | Clear search highlight |
| `<C-u>` | n | Half-page up + re-center |
| `<C-d>` | n | Half-page down + re-center |
| `B` | n, v | Jump to first word of line (`0w`) |
| `E` | n, v | Jump to end of line (`$`) |
| `<C-a>` | n | Select all (`ggVG`) |
| `Ø` | n | Jump cursor into next quoted string (Norwegian keyboard) |

---

### VSCode-Only — `lua/keymaps/vscode.lua`
Only active when running inside VSCode via vscode-neovim. All mappings delegate to VSCode commands via `require('vscode').action(...)`.

| Keys | Mode | VSCode Command |
|------|------|----------------|
| `K` | n, v | Move line(s) up |
| `J` | n, v | Move line(s) down |
| `<leader>pn` | n, v | Next diagnostic/problem |
| `<leader>pp` | n, v | Previous diagnostic/problem |
| `<leader>fa` | n, v | Global search (Periscope) |
| `<leader>fd` | n, v | Format document |
| `<leader>ff` | n, v | Search in current file (Periscope) |
| `<leader>ku` | n, v | Remove comment |
| `<leader>kc` | n, v | Add comment |
| `<leader>gr` | n, v | Go to references |
| `<leader>fe` | n | Focus file explorer |
| `<leader>fg` | n | Focus Source Control panel |
| `<leader>ha` | n, v | Harpoon: add current file |
| `<leader>hh` | n, v | Harpoon: quick pick |
| `<leader>he` | n, v | Harpoon: edit list |
| `<leader>h1`–`h9` | n, v | Harpoon: jump to slot 1–9 |
| `<leader>le` | n, v | Show all open editors |
| `<leader>ee` | n, v | Focus left editor group |
| `<leader>bb` | n, v | Toggle sidebar |
| `<leader>tt` | n, v | Toggle terminal |
| `<leader>tr` | n, v | Move panel to right |
| `<leader>tb` | n, v | Move panel to bottom |

---

### Standalone Neovim — `lua/keymaps/regular.lua`
Active only in standalone Neovim (currently sparse; most bindings come from `shared.lua` and plugin files).

| Keys | Mode | Action |
|------|------|--------|
| `<leader>y` | n, v | Yank to clipboard (also in shared) |
| `<C-s>` | n, v | Save file (also in shared) |

Also sets `vim.opt.clipboard = 'unnamedplus'` so all yanks go to the system clipboard by default.

---

### LSP — `lua/lsp_config.lua` (buffer-local, set in `on_attach`)
These are only active in buffers where an LSP server has attached.

| Keys | Action |
|------|--------|
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>gd` | Telescope: go to definition |
| `<leader>gr` | Telescope: go to references |
| `<leader>gi` | Telescope: go to implementation |
| `<leader>td` | Telescope: type definition |
| `<leader>ds` | Telescope: document symbols |
| `<leader>ws` | Telescope: workspace symbols |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `gD` | Go to declaration |

User command `:Format` → `vim.lsp.buf.format()`.

---

### Telescope — `lua/plugins/telescope.lua`

| Keys | Action |
|------|--------|
| `<leader>ff` | Find files |

> Note: `<leader>ff` means **find files** in Neovim and **search in current file** in VSCode. These are separate code paths (not a runtime conflict) but be aware of the semantic difference.

---

### Completion (nvim-cmp) — `lua/plugins/cmp.lua`
Insert-mode only; active when the completion menu is visible.

| Keys | Action |
|------|--------|
| `<C-n>` | Next completion item |
| `<C-p>` | Previous completion item |
| `<Tab>` | Next item (or fallback) |
| `<S-Tab>` | Previous item (or fallback) |
| `<CR>` | Confirm selection |

---

## Plugins

All plugin specs live in `lua/plugins/`. lazy.nvim auto-discovers every file in that directory — **no manual registration is needed**. Just create a new file and return a valid plugin spec.

| Plugin | File | Purpose |
|--------|------|---------|
| `folke/tokyonight.nvim` | `theme.lua` | Colorscheme (`night` style) |
| `nvim-lualine/lualine.nvim` | `lualine.lua` | Statusline |
| `nvim-telescope/telescope.nvim` | `telescope.lua` | Fuzzy file/text finder |
| `nvim-lua/plenary.nvim` | (telescope dep) | Lua utility library |
| `neovim/nvim-lspconfig` | `lsp.lua` | LSP client configs |
| `williamboman/mason.nvim` | `lsp.lua` | LSP/tool installer UI |
| `williamboman/mason-lspconfig.nvim` | `lsp.lua` | Bridges Mason + lspconfig |
| `j-hui/fidget.nvim` | `lsp.lua` | LSP progress spinner |
| `folke/neodev.nvim` | `lsp.lua` | Lua LSP enhancements for Neovim config dev |
| `hrsh7th/nvim-cmp` | `cmp.lua` | Completion engine |
| `hrsh7th/cmp-nvim-lsp` | `cmp.lua` | LSP completion source |
| `hrsh7th/cmp-path` | `cmp.lua` | Path completion source |

---

## LSP Configuration

LSP server definitions are centralized in `lua/lsp_config.lua` (module pattern). The `lsp.lua` plugin spec reads from this module to drive Mason auto-installation and lspconfig setup.

**Currently configured servers:**

| Server | Notes |
|--------|-------|
| `lua_ls` | Lua Language Server; configured for Neovim API awareness via neodev |

To add a new language server:
1. Add an entry to the `servers` table in `lua/lsp_config.lua`.
2. Mason will auto-install it; lspconfig will auto-configure it with shared `on_attach` and `capabilities`.

No external formatter or linter plugins are currently configured. Formatting goes through `vim.lsp.buf.format()`.

---

## Options (`lua/options/options.lua`)

| Option | Value |
|--------|-------|
| Leader | `<Space>` |
| `updatetime` | 50ms |
| `timeoutlen` | 300ms |
| `tabstop` / `shiftwidth` | 2 |
| `scrolloff` | 8 |
| `number` + `relativenumber` | true |
| `hlsearch` | false |
| `incsearch` | true |
| `ignorecase` + `smartcase` | true |
| `termguicolors` | true |

---

## Norwegian Keyboard Notes

The user types on a Norwegian keyboard. Some bindings use Norwegian characters as convenient Vim keys:

- `Ø` (shared) — jump into next quoted string
- `ø` (legacy file) — end of line (`$`)

When adding new bindings, consider that characters like `Ø`, `Æ`, `Å`, `ø`, `æ`, `å` are reachable home-row-adjacent keys on this layout and are good candidates for frequent-action bindings.

---

## Known Issues / Tech Debt

| Issue | Location | Details |
|-------|----------|---------|
| Dead code | `lua/bru/vscode_keymaps.lua` | Never required; legacy file predating the `keymaps/` split. Contains useful extras (`n`/`N` recentering, `ø=$`) that could be migrated. |
| Duplicate mapping | `lua/keymaps/vscode.lua` lines 12 & 14 | `<leader>fa` is mapped twice to `periscope.search` — second is redundant. |
| Copilot lualine component | `lua/plugins/lualine.lua` line 12 | References `"copilot"` but no Copilot plugin is in `lazy-lock.json` — component silently inactive. |
| No snippet engine | `lua/plugins/cmp.lua` | luasnip was removed; `<Tab>` falls back gracefully but no snippet expansion exists. |
| `regular.lua` duplicates `shared.lua` | `lua/keymaps/regular.lua` | `<leader>y` and `<C-s>` are already in `shared.lua`; the copies in `regular.lua` are redundant. |

---

## How to Add Things

### New plugin
Create `lua/plugins/myplugin.lua` returning a lazy.nvim spec. No registration needed.

### New keymap (standalone Neovim only)
Add to `lua/keymaps/regular.lua` inside the returned function.

### New keymap (VSCode only)
Add to `lua/keymaps/vscode.lua`. Use `require('vscode').action('command.id')`.

### New keymap (both environments)
Add to `lua/keymaps/shared.lua`. Must not depend on any plugin.

### New LSP server
Add to the `servers` table in `lua/lsp_config.lua`. Mason handles installation automatically.

---

## OpenSpec workflow

<!-- egg-setup: egg-setup 1, 2026-10-30 -->

Changes are tracked with OpenSpec. Build them with `/opsx-apply`, following this loop on top of it.
Notes go in the change's `devlog/` folder via the `egg-devlog` skill.

### Gates

Run through `gates.ps1` (`pwsh ./gates.ps1 <target>`); a gate passed only if you saw its
`LABEL_EXIT:0`. Quote exit lines, never paraphrase them.

- `pwsh ./gates.ps1 build` — starts Neovim headless with `init.lua`; fails on any startup error.
- `pwsh ./gates.ps1 format` — `stylua --check` over `init.lua` and `lua/`, using `stylua.toml`.
- `pwsh ./gates.ps1 validate` — `openspec validate --strict` on every active change.
- `pwsh ./gates.ps1 gates` — all of the above.

`pwsh ./gates.ps1 deps` is separate: it checks that every tool and login in `docs/dependencies.md` is
present.

### Starting a change

1. Ask which change to build, even if there is only one (`pwsh ./gates.ps1 changes`).
2. Resume point: the newest devlog note's `## Next` and the first unticked task in `tasks.md`. In a
   fresh session, the `egg-pickup` skill does this and steps 3–5.
3. `pwsh ./gates.ps1 deps` → `DEPS_EXIT:0`. If not, stop: offer to install what's missing, and hand any
   login to the user as `!<cmd>` — never try to authenticate yourself.
4. Clean working tree (unless resuming a recorded stop), `pwsh ./gates.ps1 validate` green, on branch
   `change/<change-name>`.
5. Read `proposal.md`, `design.md`, and the specs the change touches.

A task that needs a tool, SDK, service or login not in `docs/dependencies.md` is a stop: ask before
adding it. Once agreed, add its row there and its check to the `deps` target in `gates.ps1` in the same
section commit, and say why in a devlog note.

### Each section (`## N.` in `tasks.md`), in order

1. Note the base commit (`git rev-parse --short HEAD`) — in a start note for larger sections.
2. Implement the section's tasks, with tests. Write a devlog note for any non-obvious decision.
3. **Self-review** `git diff <base>` plus untracked files, against the spec requirements rather than
   just the tasks: missing requirements, untested behaviour, swallowed errors, dead or stub code,
   contracts that drifted from earlier sections, violations of `design.md ## Decisions`.
   Fix what you find.
4. `pwsh ./gates.ps1 gates` — all green. A section may land red only as a deliberate, stated call (e.g.
   a test a later section turns green), recorded in the devlog note and the commit body.
5. Tick the section's tasks and write the section-done devlog note. Assume the context will be cleared
   before the next section, so the note must be enough to resume from alone. Its `## Next` names the
   next section and its first task (or the whole-change review, after the last section). It also records
   anything this session knows that the repo doesn't: the user's answers, gotchas you hit, deferred
   nits, decisions in flight. Then make **one commit** for the section:
   ```
   feat(<change-name>): <section summary> (§N)

   - N.1 <task summary>
   - N.2 <task summary>
   ```
6. **Hand off.** Run the `egg-handoff` skill to check that a cold session can resume from the repo
   alone. Then end the turn by asking whether the user wants to start a new session (`/new`) or restart
   `opencode` before the next step. If they'd rather keep going, continue in this session.

### Finishing a change

1. Self-review the whole change, `git diff <first-section-base>..HEAD`: duplicated abstractions,
   leftover scaffolding, cross-section drift, and whether the spec is genuinely satisfied.
2. Write the change-done devlog note and report to the user. Then **offer** an independent code review
   of the change branch before archiving (e.g. a fresh-context `general` subagent reviewing
   `git diff <first-section-base>..HEAD` against the specs), and run it if they say yes.
3. Fixes from either review don't land as loose commits. Add them to `tasks.md` as one or more new
   sections (`## N+1. Review fixes: <theme>`), agree them with the user, and build them with the
   section loop above, hand-off included. Then return to step 2.
4. Once the review is done or declined and no fix sections are open, **offer** `/opsx-archive`, and
   wait for a yes.

### Stop and ask

Stop when: a requirement is ambiguous or contradicts the spec or design; scope would change; a task
needs human verification (how keymaps feel in real Neovim or inside VSCode via vscode-neovim,
theme/statusline look, LSP behaviour in a live buffer); or gates won't go green after two honest
attempts.

To stop: leave work uncommitted and tasks unticked; write a `stopped-…` devlog note stating exactly what
blocked and the question; end the turn with the question — for human verification, a copy-pasteable
recipe. Never decide a product question yourself and flag it afterwards.

Before the user ends a session or clears the context at any other point, run the `egg-handoff` skill.
Resume with the `egg-pickup` skill.
