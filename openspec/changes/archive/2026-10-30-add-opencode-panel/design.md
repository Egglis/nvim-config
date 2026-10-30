# Design

## Context

Standalone Neovim loads plugins through lazy.nvim, one spec file per plugin in `lua/plugins/`. Telescope and nvim-cmp are already installed. `<leader>o…` is unused. The `config-health` spec requires a clean, message-free startup, including on a machine with no plugins installed, and the `keymaps` spec requires a `desc` on every mapping outside `shared.lua`/`vscode.lua`.

`sudo-tee/opencode.nvim` is a Neovim frontend for OpenCode: right-side split with input + output buffers, multiple sessions as panel tabs, session picker, diff review with revert. It spawns an `opencode` server itself, works with OpenCode V1 and V2, and needs Neovim 0.10.3+.

## Goals / Non-Goals

**Goals:** VSCode-like right-hand OpenCode panel; a hotkey for a new session in the current workspace; minimal config on top of plugin defaults; no startup cost.

**Non-Goals:** VSCode mappings; custom layouts or keymap remapping beyond what is needed; quick-chat tuning.

## Decisions

1. **Plugin: `sudo-tee/opencode.nvim`** over `nickjvandyke/opencode.nvim` (TUI in a terminal) and a hand-rolled terminal split. The user chose it: a native chat panel matches how they work in VSCode, and the config is mostly AI-driven.
2. **Keep the plugin's default keymaps** (`default_global_keymaps = true`, prefix `<leader>o`). They all carry a `desc`, don't collide with anything in this config, and match the plugin's docs. New session = `<leader>oI` (`open_input_new_session`), toggle = `<leader>og`.
3. **Layout options set explicitly** even where they equal defaults: `ui.position = 'right'`, `ui.window_width = 0.40`, so the spec's behaviour doesn't depend on upstream defaults.
4. **Workspace scoping** relies on the plugin's server starting in Neovim's cwd; `lock_session_to_directory = true` so sessions from other projects aren't picked up when switching cwd.
5. **Lazy loading:** the lazy spec uses `cmd = 'Opencode'` and a `keys` list for `<leader>og`, `<leader>oi`, `<leader>oI` (each with `desc`). The plugin's `setup` then registers the rest of its `<leader>o` keys on first use. This keeps startup message-free and starts no server until needed.
6. **Integrations with what's installed:** `preferred_picker = 'telescope'`; nvim-cmp listed as a dependency for prompt completion; `render-markdown.nvim` added as a dependency limited to `ft = { 'markdown', 'opencode_output' }`, with `anti_conceal` disabled per the plugin's README.
7. **Dependency:** the `opencode` CLI becomes a row in `docs/dependencies.md` and a `Check` in the `deps` target (`opencode --version`). Connecting a provider is a user login step (`opencode` then `/connect`); the agent never does it.

## Risks / Trade-offs

- **Lazy keys vs. plugin keys:** declaring three keys in lazy and letting `setup` re-map them could double-register. Mitigation: lazy `keys` entries only trigger loading; the plugin's own mapping replaces them on load. Verify with `:verbose nmap <leader>og` after first use.
- **render-markdown is a second new plugin.** Trade-off accepted for readable output; it's filetype-scoped so it doesn't affect other buffers beyond markdown.
- **Upstream defaults change.** Pinned via `lazy-lock.json`; layout values set explicitly (Decision 3).
- **Behaviour in a live buffer can't be gated headlessly** (panel position, session creation, provider responses). This needs human verification.
