# Proposal

## Why

The user wants to run `dotnet` and other project commands without leaving standalone Neovim. Right now
there is no terminal setup at all. On top of that, Neovim on Windows uses `cmd.exe` as its shell, so
`:terminal` and `:!` don't get pwsh 7, the user's profile aliases or the oh-my-posh prompt. VSCode
already has terminal keys (`<leader>tt`, `<leader>tr`, `<leader>tb`) that standalone Neovim lacks.

## What Changes

- Make **pwsh 7** Neovim's shell in standalone mode (`shell`, `shellcmdflag`, `shellredir`,
  `shellpipe`, `shellquote`, `shellxquote`, following `:h shell-powershell`). Interactive terminals load
  the user's profile. `:!` and `system()` calls skip it (`-NoProfile`) so they stay fast.
- Add `folke/snacks.nvim` with **only the `terminal` module enabled** (`lua/plugins/snacks.lua`),
  lazy-loaded on its keys. Other snacks modules stay off; later changes for the readme TODOs (git UI,
  file tree, recent projects) can turn them on.
- Give standalone Neovim the same terminal keys as VSCode:
  - `<leader>tt`: toggle the terminal. It opens at the bottom, and hiding it keeps the shell process
    alive. A count (`2<leader>tt`) picks a different terminal.
  - `<leader>tr`: move the terminal panel to the right.
  - `<leader>tb`: move it to the bottom.
- Inside the terminal, use snacks' defaults: double `<Esc>` goes to normal mode and `q` in normal mode
  hides the panel.
- Update `AGENTS.md` (plugin table, directory tree, options table, a new "Terminal" keymap section) and
  the readme TODO. In `docs/dependencies.md`, note that pwsh is now also needed at runtime.

Out of scope: task runners (overseer.nvim), .NET-specific tooling (easy-dotnet.nvim), sending lines or
selections to the terminal, any other snacks module, and any change to `lua/keymaps/vscode.lua` or
`lua/keymaps/shared.lua`.

## Capabilities

### New Capabilities
- `terminal`: the built-in terminal panel in standalone Neovim. Covers where it opens, how it is toggled
  and moved, that hiding keeps it running, multiple numbered terminals, and that it stays out of VSCode
  mode and startup.

### Modified Capabilities
- `editor-options`: adds a requirement that standalone Neovim uses pwsh 7 as its shell.

## Impact

- New: `lua/plugins/snacks.lua`.
- Changed: `lua/config/options.lua` (shell options, standalone block only).
- New plugin: `folke/snacks.nvim`, pinned in `lazy-lock.json`.
- `:!`, `:make`, `system()` and every plugin that calls the shell with a string command now go through
  pwsh, not cmd.exe.
- No new external tool: pwsh is already in `docs/dependencies.md` and checked by `gates.ps1 deps`.
- Docs: `AGENTS.md`, `readme.md`, `docs/dependencies.md` (the "Why" column for PowerShell).
