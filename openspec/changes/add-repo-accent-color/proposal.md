# Proposal

## Why

I switch between many terminal windows, each running Neovim in a different repo, and they all look
identical. I need to tell at a glance which repo a window belongs to, without changing the editor's
colorscheme.

## What Changes

- Standalone Neovim gets a per-repo **accent color**, shown only in the chrome: a repo-name block at the
  left of the statusline (lualine), tinted with the accent. The tokyonight colorscheme and the editing
  area stay exactly as they are.
- The accent comes from the repo's existing `.vscode/settings.json`
  (`workbench.colorCustomizations` → `statusBar.background`, else `titleBar.activeBackground`), so a repo
  that is already colour-coded in VSCode gets the same colour in Neovim.
- Repos without such a setting get a stable accent derived from the repo folder name, picked from a
  small palette of tokyonight colors — the same repo always gets the same color.
- The terminal window/tab title is set to the repo name (`title`/`titlestring`), so the terminal's own top
  bar also identifies the repo.
- Outside a git repo nothing is tinted and the title falls back to the folder name.
- The accent follows `:cd` / directory changes.
- VSCode mode is untouched (VSCode already shows its own colours).

## Capabilities

### New Capabilities
- `repo-accent`: identifying the current repo in standalone Neovim through a subtle accent color in the
  statusline and the terminal title, sourced from the repo's VSCode settings or derived from its name.

### Modified Capabilities

## Impact

- New module `lua/config/repo_accent.lua` (no plugin requires at load).
- `lua/plugins/lualine.lua` gains a repo component on the left.
- `init.lua` calls the module's setup in the standalone branch.
- `AGENTS.md` documents the behaviour. No new dependencies.
