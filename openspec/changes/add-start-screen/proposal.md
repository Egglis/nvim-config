# Proposal

## Why

Plain `nvim` opens an empty buffer that does nothing. The readme TODO "Other UI improvements for a
clean and simpler interface" starts here: the user wants a start screen like VSCode's welcome page,
showing which repo you're in, quick keys for the usual first actions, and recent files and projects.
snacks.nvim is already installed and has a dashboard, so no new plugin is needed.

## What Changes

- New **start screen** in standalone Neovim, shown only when Neovim starts with no file arguments
  (plain `nvim`). It uses the snacks dashboard:
  - **Header:** the repo name in the repo's accent color (the same repo and color as the top bar and
    statusline block). Outside a repo, "Neovim" in the normal header color.
  - **Menu keys**, reusing existing actions: `f` find file, `g` grep, `r` recent files, `p` projects,
    `n` new file, `c` config (`:cd` to the Neovim config + file picker), `L` Lazy, `q` quit.
  - **Recent files:** 5 entries, from the current repo when inside one, otherwise global.
  - **Projects:** 10 recent project folders. Opening one works like `<leader>fP`: a global `:cd` there
    (the repo accent follows) and then the file picker.
  - Numbered items get keys `1`–`0`, then letters. They never take a menu key or `h`/`j`/`k`/`l`.
- **Startup loading changes:** snacks loads at startup **only** when the start screen will be shown.
  Starting with a file (`nvim file.lua`, `nvim .`) keeps snacks fully lazy, as now.
- Docs: `AGENTS.md` (start screen section, plugin table, snacks loading note), readme TODO note.

Out of scope: what `nvim .` shows (netrw stays; the file-tree TODO decides that), sessions/"restore
session", other UI items from the TODO (lualine trimming, borders, which-key, notifier, indent guides,
git signs), and VSCode mode, which is unchanged.

## Capabilities

### New Capabilities
- `start-screen`: the start screen in standalone Neovim: when it appears, its header, menu keys,
  recent files and projects lists, and that it stays out of VSCode mode.

### Modified Capabilities
- `picker`: "Pickers load on demand" gains an exception: when the start screen is shown, the picker
  plugin may load at startup.
- `terminal`: "Terminal is loaded on demand" gains the same exception for the plugin. Still no shell
  process starts at startup.

## Impact

- Changed: `lua/plugins/snacks.lua` (conditional `lazy`, `dashboard` options and sections),
  `lua/config/repo_accent.lua` (exposes what the header needs, if it doesn't already).
- No new plugin or external tool; `docs/dependencies.md` is unchanged.
- Startup cost: only on plain `nvim`, where snacks and its dashboard now load.
- Docs: `AGENTS.md`, `readme.md`.
