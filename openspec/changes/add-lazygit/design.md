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

lazygit fact: on Windows it runs edit commands through `cmd /c`. Its `nvim-remote` preset writes POSIX
shell syntax (`[ -z "$NVIM" ] && …`), which cmd can't parse, so `e` fails with "'[' is not recognized"
(lazygit issues #3467 and #5696, both open). lazygit also escapes `%`, so a cmd `%NVIM%` workaround
fails too.

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
3. **Fix `e` on Windows by replacing the preset with a pwsh command.** In `opts.lazygit.config.os`,
   clear `editPreset` and set `edit` and `editAtLine` to a `pwsh -NoProfile -Command` line that uses
   `$env:NVIM` (no `%` for lazygit to escape). The line first sends `<C-\><C-n><cmd>close<CR>` to the
   parent Neovim to close the lazygit float, then `nvim --server $env:NVIM --remote {{filename}}`, and
   for `editAtLine` it also jumps to `{{line}}`. Set `editInTerminal = false`, so lazygit doesn't suspend
   itself. Closing the float keeps the lazygit process alive, so the next `<leader>gg` brings back the
   same session. The exact quoting is checked by reading the generated `lazygit-theme.yml` and by
   pressing `e`; keep the Windows-only override behind `vim.fn.has("win32") == 1`, so the snacks
   default stays on other systems.
   *Alternatives:* `editPreset = "nvim"` (opens a nested Neovim inside the float, which breaks the spec);
   `nvr`/neovim-remote (an extra Python tool); a Git Bash shell (lazygit can't be told to use it for
   edits, and it isn't a listed dependency). If no quoting works, that is a stop: ask the user rather
   than shipping a nested editor.
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

- [`<C-t>` is mapped in terminal mode for the terminal toggle, so inside lazygit it toggles a terminal
  instead of reaching lazygit (lazygit uses `ctrl+t` for its external diff tool)] → Rarely used here.
  Accepted; noted in `AGENTS.md`.
- [Snacks' terminal keys such as `<Esc><Esc>` (leave terminal mode) may also apply in the lazygit float,
  so a double `<Esc>` leaves lazygit's input] → Checked by hand; if it gets in the way, set
  `opts.lazygit.win.keys` to drop it.
- [The pwsh edit command depends on lazygit's quoting rules, which change between versions] → The
  human check covers `e`; the lazygit version is in `docs/dependencies.md` only as "any", so a future
  break shows up as a broken `e`, not a startup error.
- [`<leader>go` assumes a remote snacks gitbrowse knows (GitHub, GitLab, …)] → Fine for this repo
  (`github.com/Egglis/nvim-config`); other remotes get snacks' own message.
- [A double `<leader>g` group: `gd/gr/gi` are LSP and buffer-local, the rest are global] → No overlap
  in letters, so no wait time on any key.
