# Proposal

## Why

The readme TODO "Git tree/sidebar for simple git actions" is still open. Standalone Neovim has no way to
stage, commit or push, and the only git view is the `<leader>fg` status picker. The user wants it kept
simple and built on snacks.nvim, which is already installed and ships a lazygit integration plus git
pickers we don't use yet.

## What Changes

- New **git keys** in standalone Neovim, all under `<leader>g`. They avoid `d`, `r` and `i`, which stay
  the LSP keys:
  - `<leader>gg` opens **lazygit** in a float (`Snacks.lazygit()`), themed from the colorscheme. In
    lazygit, `e` on a file opens it in **this** Neovim, not a nested one.
  - `<leader>gs` git status, `<leader>gl` git log, `<leader>gf` history of the current file,
    `<leader>gb` branches, `<leader>gB` blame of the current line, `<leader>go` open the current file on
    the remote (GitHub) in the browser.
- `<leader>fg` stays as it is (git status), so it still matches VSCode's Source Control key.
- New external tool: **lazygit** (`winget install JesseDuffield.lazygit`), added to
  `docs/dependencies.md` and the `deps` gate.
- Docs: a Git section and the snacks row in `AGENTS.md`, and the git TODO ticked in `readme.md`.

Out of scope: gutter change markers (gitsigns), Neogit/fugitive/codediff, a file tree with git status
(its own TODO), and VSCode mode, which is unchanged.

## Capabilities

### New Capabilities
- `git`: git actions in standalone Neovim: the lazygit panel (opening, closing, editing a file from it),
  the git lookup keys (status, log, file history, branches, line blame, open on remote), loading on
  demand, and staying out of VSCode mode.

### Modified Capabilities
None. `<leader>fg` and the other picker requirements are unchanged; the new keys load snacks the same
way the picker keys already do.

## Impact

- Changed: `lua/plugins/snacks.lua` (new `keys`, an `opts.lazygit` block).
- New dependency: lazygit, in `docs/dependencies.md` and `gates.ps1` (`deps` target).
- Docs: `AGENTS.md`, `readme.md`.
- No new Neovim plugin; `lazy-lock.json` is unchanged.
