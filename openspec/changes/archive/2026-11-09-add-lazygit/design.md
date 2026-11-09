# Design

## Context

See proposal.md (Why). `lua/plugins/snacks.lua` holds the snacks spec with `opts = { dashboard,
terminal, picker }`. It loads at startup only on a plain `nvim` (start screen), and otherwise lazily on
its `keys` or the first `vim.ui.select`. `<leader>gd/gr/gi` are buffer-local LSP keys from
`lua/lsp/keymaps.lua`. `<C-t>` is mapped in normal and terminal mode to toggle the terminal.

Snacks facts, from the installed source (`882c996`):
- `Snacks.lazygit()` runs `lazygit` in a snacks terminal float (style `lazygit`). With
  `configure = true` it writes a theme file at `stdpath("cache")/lazygit-theme.yml` from the
  colorscheme, merges `opts.lazygit.config` into it, and points lazygit at it through
  `LG_CONFIG_FILE` (after the user's own lazygit config, if any). The default `config` sets
  `os.editPreset = "nvim-remote"`. Snacks' YAML writer is simple: a string that needs literal quotes in
  the YAML must be quoted twice.
- Pickers exist for `git_status` (`<Tab>` stage, `<C-r>` restore), `git_log`, `git_log_file`,
  `git_branches` (confirm = checkout, `<C-a>` add, `<C-x>` delete). `Snacks.git.blame_line()` shows the
  current line's commit in a float. `Snacks.gitbrowse()` opens the file on the remote's website.

lazygit fact: on Windows it runs edit commands through cmd. Its `nvim-remote` preset writes POSIX
shell syntax (`[ -z "$NVIM" ] && …`), which cmd can't parse, so `e` fails with "'[' is not recognized"
(lazygit issues #3467 and #5696, both open). Older lazygit versions also escaped `%`; 0.66.1 (installed)
hands cmd the command line as is.

## Goals / Non-Goals

**Goals:** the `git` spec, using only snacks and lazygit; one place (`snacks.lua`) for all of it;
`e` in lazygit works on Windows.

**Non-Goals:** a lazygit config file of our own (`%APPDATA%\lazygit\config.yml`) beyond what snacks
generates; lazygit keybinding changes; gitsigns or other gutter markers; `<leader>g` keys in VSCode.

## Decisions

1. **Everything in `lua/plugins/snacks.lua`.** The new keys go in the spec's `keys` list next to the
   `<leader>f…` keys, and a `lazygit` table goes in `opts`. lazy.nvim loads snacks on these keys like
   the others, so no loading change is needed.
   *Alternative:* a separate `lua/plugins/git.lua` spec for snacks. Rejected: lazy.nvim would merge two
   specs of the same plugin, which is harder to follow than one file.
2. **Key to function mapping:** `<leader>gg` → `Snacks.lazygit()`, `<leader>gs` →
   `Snacks.picker.git_status()`, `<leader>gl` → `Snacks.picker.git_log()`, `<leader>gf` →
   `Snacks.picker.git_log_file()`, `<leader>gb` → `Snacks.picker.git_branches()`, `<leader>gB` →
   `Snacks.git.blame_line()`, `<leader>go` → `Snacks.gitbrowse()`. Each gets a `desc` in the
   `[G]it …` style of the existing keys. `<leader>fg` is unchanged.
   *Alternative:* `Snacks.lazygit.log()`/`log_file()` instead of pickers for `gl`/`gf`. Rejected: the
   pickers are faster to search and preview, and lazygit is one key away.
3. **Fix `e` on Windows by replacing the preset with cmd commands.** lazygit 0.66 runs edits as a raw
   `cmd /s /c "<command>"`, with no extra escaping, so cmd syntax works and `%NVIM%` expands. In
   `opts.lazygit.config.os`, clear `editPreset` and set `edit`, `editAtLine` and `openDirInEditor` to
   `nvim --server %NVIM% --remote-send "<C-\><C-n><cmd>close<CR>" && nvim --server %NVIM% --remote
   <file>`; `editAtLine` then also sends `:{{line}}<CR>`. The first part closes the lazygit float in the
   parent Neovim, the second opens the file there. lazygit passes absolute, quoted paths, so files with
   spaces work. `editAtLineAndWait` (lazygit waits for the editor to exit) stays a nested
   `nvim +{{line}} {{filename}}`, as in the upstream preset. Set `editInTerminal = false`, so lazygit
   doesn't suspend itself. Closing the float keeps the lazygit process alive, so the next `<leader>gg`
   brings back the same session. Keep the override behind `vim.fn.has("win32") == 1`, so the snacks
   default stays on other systems.
   *Alternatives:* a `pwsh -NoProfile -Command …` line using `$env:NVIM` (the original plan): tested
   and rejected, because cmd still sees the `<` in `'<C-\>…'` as a redirect, since single quotes mean
   nothing to cmd. `editPreset = "nvim"` (opens a nested Neovim inside the float, which breaks the
   spec). `nvr`/neovim-remote (an extra Python tool).
4. **lazygit is a dependency installed with winget** (`JesseDuffield.lazygit`). Its row goes in
   `docs/dependencies.md`, and `gates.ps1 deps` gets
   `Check 'MISSING lazygit - winget install JesseDuffield.lazygit' { lazygit --version }`.
   A winget install may not update `PATH` in an already-open shell; the deps check is run in a new
   `pwsh` process.
5. **Theme and icons: snacks defaults.** The theme follows tokyonight. `nerdFontsVersion = "3"` stays,
   since the terminal already shows Nerd Font icons elsewhere (lualine, opencode). If the human check
   shows broken icons, it becomes `""`.
6. **Checking it:** the build gate covers startup. Headless runs can check that the keys exist, that
   calling the picker functions in a non-repo folder raises no Lua error, and that the generated
   `lazygit-theme.yml` holds the edit commands. Opening lazygit, the theme, `e`, gitbrowse and the
   VSCode side need a human check.

## Risks / Trade-offs

- [`<C-t>` is mapped in terminal mode for the terminal toggle; the lazygit float is a snacks terminal, so
  inside lazygit `<C-t>` hides it, and lazygit's own `ctrl+t` (external diff tool) is unreachable] →
  Rarely used here. Accepted; noted in `AGENTS.md`.
- [`<leader>tr`/`<leader>tb` move every snacks terminal, which would turn the lazygit float into a split]
  → `move_terminals` only moves shell terminals (no `cmd`), found while building §1.
- [Snacks' terminal keys such as `<Esc><Esc>` (leave terminal mode) may also apply in the lazygit float,
  so a double `<Esc>` leaves lazygit's input] → Checked by hand; if it gets in the way, set
  `opts.lazygit.win.keys` to drop it.
- [The cmd edit commands depend on lazygit passing the command line to cmd unchanged, as 0.66 does] → The
  human check covers `e`; the lazygit version is in `docs/dependencies.md` only as "any", so a future
  break shows up as a broken `e`, not a startup error.
- [`<leader>go` assumes a remote snacks gitbrowse knows (GitHub, GitLab, …)] → Fine for this repo
  (`github.com/Egglis/nvim-config`); other remotes get snacks' own message.
- [A double `<leader>g` group: `gd/gr/gi` are LSP and buffer-local, the rest are global] → No overlap
  in letters, so no wait time on any key.
