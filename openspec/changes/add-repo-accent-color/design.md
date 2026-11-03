# Design

## Context

Standalone Neovim uses tokyonight `night` and lualine with `theme = "auto"`. The user runs one Neovim
per repo in separate terminal windows and wants a subtle but obvious per-repo colour cue, without
changing the colorscheme. VSCode repos are often already colour-coded via
`workbench.colorCustomizations` (`statusBar.background`, `titleBar.activeBackground`). Neovim is 0.11.0,
so `vim.fs.root`, `vim.json` and `vim.fn.sha256` are available.

## Goals / Non-Goals

**Goals:** recognise the repo at a glance from the statusline and the terminal tab/title; reuse the
VSCode colour where one exists; stable colour otherwise; no change to the editing area.

**Non-Goals:** switching colorschemes or palettes per repo; tinting the whole statusline or window
borders; per-buffer repo detection (the cue identifies the window's workspace, not each file);
anything in VSCode mode.

## Decisions

1. **Repo = git root of the cwd**, via `vim.fs.root(vim.fn.getcwd(), ".git")`, recomputed on `VimEnter`
   and `DirChanged`. Cwd (not the current buffer) because the goal is identifying the terminal window's
   workspace; opening a file from another repo should not flip the colour.
2. **Accent source order:** `statusBar.background` → `titleBar.activeBackground` from
   `<root>/.vscode/settings.json` → hash palette. Only `#rrggbb` (and `#rrggbbaa`, alpha dropped) are
   accepted. Theme-scoped keys (`"[Tokyo Night]": {...}`) are not read — keep it to the plain keys.
3. **JSONC handling:** a small string-aware stripper removes `//` and `/* */` comments and trailing
   commas before `vim.json.decode`, all under `pcall`. VSCode settings files routinely contain both
   (the user's own example does).
4. **Derived colour:** `vim.fn.sha256(folder_name)`, first 8 hex digits mod palette size, palette =
   tokyonight night accents (blue, cyan, green, magenta, orange, purple, red, teal, yellow) hard-coded
   as hex so the module does not require the plugin.
5. **Display:** the repo block is the first item of `lualine_a`, followed by the default `mode`, with
   its own `color` function `{ fg = <dark>, bg = accent, gui = "bold" }`. Foreground is `#1a1b26`
   (tokyonight night bg) or `#c0caf5` chosen by the accent's luminance so dark VSCode colours like
   `#700202` stay readable. Hidden (`cond`) when there is no repo.
6. **Title:** `vim.o.title = true` and `titlestring` set to the repo (or cwd) folder name; Windows
   Terminal shows it as the tab title.
7. **Module shape:** `lua/config/repo_accent.lua` exposes `setup()`, `component()` (lualine table) and
   pure helpers (`parse_jsonc`, `color_for`) for headless checks. It never requires a plugin. `setup()`
   is called from `init.lua`'s standalone branch; lualine's spec requires the module inside its
   `opts` function.

## Risks / Trade-offs

- Hash collisions: 9 colours, so two repos can share one; the repo name in the block disambiguates, and
  a repo can pin a colour through `.vscode/settings.json`.
- Settings are read on `VimEnter`/`DirChanged` only; editing the file needs `:cd .` or a restart.
  Acceptable for a rarely changed setting.
- Terminals that ignore title escape sequences just won't show the title; the statusline still works.
