# Proposal

## Why

This config is mostly used for AI-driven coding. In VSCode the user keeps OpenCode in a panel pinned to the right and starts fresh sessions from a hotkey; standalone Neovim has no OpenCode integration at all, so that workflow is missing outside VSCode.

## What Changes

- Add `sudo-tee/opencode.nvim` as a standalone-only plugin (`lua/plugins/opencode.lua`): a native chat panel (input + output) docked on the right at 40% width, talking to an `opencode` server it starts in the current working directory.
- Hotkeys under the unused `<leader>o` prefix, using the plugin's defaults: `<leader>og` toggles the panel, `<leader>oi` opens the prompt, `<leader>oI` opens the prompt in a **new session** for the current workspace, plus the plugin's session, diff-review and revert keys.
- Wire the plugin into what the config already has: Telescope as the picker, nvim-cmp for `@`/`/`/`~` completion in the prompt, and `render-markdown.nvim` to render the output buffer.
- Lazy-load the plugin on its keys/command so startup stays clean and fast and no server is spawned until it is used.
- Add the `opencode` CLI to `docs/dependencies.md` and to the `deps` gate.
- Update `AGENTS.md` (plugin table, keymap reference).

Out of scope: any VSCode mapping (`lua/keymaps/vscode.lua` stays as the user wrote it), the experimental quick-chat feature beyond its default key, and custom layouts.

## Capabilities

### New Capabilities
- `ai-assistant`: the in-editor AI coding assistant in standalone Neovim — where the panel lives, how sessions are started and scoped to the workspace, and how it stays out of VSCode mode and startup.

### Modified Capabilities
<!-- none: existing keymaps/config-health requirements already cover descriptions, VSCode isolation and clean startup; this change must satisfy them, not change them -->

## Impact

- New: `lua/plugins/opencode.lua`.
- New plugins: `sudo-tee/opencode.nvim`, `MeanderingProgrammer/render-markdown.nvim` (pinned in `lazy-lock.json`).
- New external tool: `opencode` CLI on `PATH` with a provider connected (`docs/dependencies.md`, `gates.ps1 deps`).
- Docs: `AGENTS.md`.
