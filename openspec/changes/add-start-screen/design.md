# Design

## Context

See proposal.md (Why). `lua/plugins/snacks.lua` holds snacks with `opts = { terminal, picker }`. lazy.nvim
loads it on its `keys`, and an `init` stub loads it on the first `vim.ui.select`. The `picker` and
`terminal` specs currently forbid loading it at startup. `lua/config/repo_accent.lua` runs before
lazy.nvim (`init.lua`) and keeps `M.state = { root, name, accent, ... }`, where `root`/`accent` are nil
outside a repo and `name` is then the cwd's folder name.

Snacks dashboard facts, from the installed source:
- Snacks hooks `UIEnter` to set up `dashboard` (and `picker`, `input`, …). If snacks loads after
  `VimEnter`, that runs immediately instead.
- `dashboard.setup()` skips itself when `argc(-1) > 0`, the first buffer has a name, Neovim is headless,
  or stdin isn't a tty.
- `sections.recent_files({ limit, cwd })` filters `v:oldfiles` to `cwd` when it is given.
- `sections.projects({ limit, action, session, pick })` lists git roots of recent files. Without
  `action` it `chdir`s and opens the files picker, after a session check.
- Items with `autokey` take keys from `autokeys` (default `1234567890abc…`) after removing `h j k l q`
  and every fixed `key` used on the screen.

## Goals / Non-Goals

**Goals:** the start screen from the `start-screen` spec; zero change to startup when a file is
opened; reuse the existing actions instead of copying them.

**Non-Goals:** custom ASCII art or a figlet header; reopening the start screen later (`:lua
Snacks.dashboard()` works but gets no key); sessions; a different project list than snacks'.

## Decisions

1. **Conditional `lazy` on the snacks spec: `lazy = vim.fn.argc(-1) > 0`.** lazy.nvim reads the spec
   during `require("config.lazy")`, after Neovim has parsed its arguments, so `argc` is known. With no
   arguments, snacks loads at startup and its `UIEnter` hook draws the dashboard. With arguments,
   nothing changes from today. Keys and the `vim.ui.select` stub stay as they are; they're harmless when
   snacks is already loaded.
   *Alternatives:* `lazy = false` always (simpler, but every `nvim file` pays for it; the user chose
   against that). `event = "VimEnter"` (snacks would load after `VimEnter`. It still draws the
   dashboard, but loads on every start with a file too).
   If snacks later loads lazily in a session started with a file, its `UIEnter` setup runs
   `dashboard.setup()`, which sees `argc > 0` and does nothing. So enabling the dashboard in `opts` is
   safe for the lazy path.
2. **All dashboard config lives in `lua/plugins/snacks.lua` `opts.dashboard`**, with explicit
   `sections` (no preset `keys` list), next to the picker and terminal config. This keeps one spec per
   plugin, as before.
3. **Header = a function section** that reads `require("config.repo_accent").state` when rendered.
   With an accent, it defines a highlight `StartScreenRepo` (`fg = accent, bold`) and shows `state.name`
   centered. Without an accent, it shows "Neovim" with snacks' `SnacksDashboardHeader`. `repo_accent` is
   our own module, not a plugin, so requiring it there is fine. It probably needs no change: `state` is
   already public.
   *Alternative:* snacks' `header` preset string. It is static, so it can't follow the repo.
4. **Menu entries call the same functions as the leader keys:** `f` `Snacks.picker.files()`, `g`
   `.grep()`, `r` `.recent()`, `p` `.projects()`, `n` `:ene | startinsert`, `L` `:Lazy`, `q` `:qa`.
   `c` does `vim.cmd.cd(vim.fn.stdpath("config"))` and then `Snacks.picker.files()`, the same shape as
   the projects action (decision 6), so the accent follows.
   *Alternative:* the snacks preset `c` (picker with `cwd = config`, no `:cd`). Rejected: the user
   wanted the accent and cwd to follow.
5. **Recent files: `recent_files({ limit = 5, cwd = state.root })`**, with `cwd` nil outside a repo
   (then it's global). Because the section is built in a function, `state.root` is read at render time.
   That also means a `.vscode`-only repo root works, since it uses the same root as the accent.
6. **Projects: `projects({ limit = 10, action = open_project })`**, where `open_project(dir)` does a
   global `vim.cmd.cd(dir)` and then `Snacks.picker.files()`. That is what `<leader>fP`'s
   `load_session` does when no session plugin is installed, written out without the 100 ms timer.
   `DirChanged` then updates the repo accent.
7. **Entry keys = snacks `autokey`** with the default sequence, which already meets the "List entry
   keys" requirement (fixed keys and `hjkl q` are removed). No custom `autokeys`.
8. **Checking it:** the build gate runs headless with no arguments, so snacks now loads there, but the
   dashboard skips itself (headless). Task checks use headless runs to confirm `package.loaded.snacks`
   is set with no arguments and unset with a file argument. How the screen looks and how its keys work
   needs a human check.

## Risks / Trade-offs

- [`<leader>fP` and the start screen list projects differently: the picker uses `.git`/`package.json`/
  `Makefile` roots plus `~/dev`, the dashboard uses git roots of recent files] → Both are "recently used
  project folders", which is what the spec asks. Accepted. Unify later if it bothers the user.
- [Plain `nvim` now loads snacks and the picker module at startup] → Only that path; it's what the
  `picker`/`terminal` deltas allow. No shell starts (the terminal module creates nothing until used).
- [The header highlight is defined at render time, so a `:colorscheme` change won't recolor an
  already-drawn screen] → The screen is short-lived. Accepted.
- [`nvim +Cmd` (no file, but a command) loads snacks eagerly while the dashboard skips itself] → Rare,
  harmless. Accepted.
