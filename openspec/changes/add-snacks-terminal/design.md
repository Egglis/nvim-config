# Design

## Context

See proposal.md (Why). Neovim is 0.11.0 on Windows, and `vim.o.shell` is currently `cmd.exe`. pwsh 7 is
installed and already in `docs/dependencies.md`. The user's profile runs oh-my-posh, so it is slow
enough to notice. Plugins live in `lua/plugins/` (lazy.nvim auto-discovers them) and are lazy-loaded on
keys, like `opencode.lua`. `<leader>tt`, `<leader>tr` and `<leader>tb` already exist in
`lua/keymaps/vscode.lua`. The only standalone `<leader>t…` map is the buffer-local `<leader>td` (LSP).
The opencode panel also docks on the right.

Snacks terminal API, from `lua/snacks/terminal.lua` on `main`:
- `Snacks.terminal.focus(cmd, opts)` focuses the terminal, or hides it if it is the current buffer.
- A terminal's id is `cmd` + `cwd` + `env` + `vim.v.count1`.
- `opts.win.position` is only read when the terminal is created. The default is `"bottom"` when no
  `cmd` is given.
- The default style already has `q = "hide"` and double-`<Esc>` to normal mode. `stack = true` stacks
  split terminals that share a position.
- With no `cmd`, it runs `vim.o.shell`.

## Goals / Non-Goals

**Goals:** a terminal panel that toggles, keeps its process running when hidden, and moves between
bottom and right, using the VSCode keys. pwsh everywhere Neovim shells out. Nothing loads at startup.

**Non-Goals:** floating terminals, terminal-mode window navigation keys, a terminal picker, persistence
across Neovim restarts.

## Decisions

1. **Plugin file is `lua/plugins/snacks.lua`, named after the plugin, not the feature.** Later changes
   will turn on more snacks modules in the same spec. `opts = { terminal = {} }` only, with every other
   module left at its default (off). It is lazy-loaded through `keys`.
   *Alternative:* `lazy = false, priority = 1000`, as snacks recommends for modules like
   `bigfile`/`dashboard`. The terminal doesn't need it, and the `terminal` spec forbids loading it at
   startup. A later change that enables those modules can switch to eager loading.
2. **`<leader>tt` calls `Snacks.terminal.focus()`, not `toggle()`.** `focus` jumps into a terminal
   that is visible but unfocused, and hides it only when you're already in it. That matches VSCode's
   terminal toggle. A count picks terminal N, because snacks reads `vim.v.count1`.
3. **No `<leader>` mapping in terminal mode; `<C-t>` toggles instead.** Space would wait `timeoutlen`
   on every keystroke (the same issue noted in `opencode.lua` for insert mode). The user found double
   `<Esc>` + `<leader>tt` too slow, so `<C-t>` (normal + terminal mode) does the same as `<leader>tt`.
   pwsh/PSReadLine has no default Ctrl+t binding. It replaces Vim's normal-mode `<C-t>` (tag stack pop),
   which this config doesn't use (`<C-o>` still jumps back).
   Both keys share one toggle: if the current buffer is a snacks terminal and no count is given, hide
   *that* terminal. Otherwise call `focus()`. Without this, `<C-t>` in terminal 2 would jump to terminal
   1 (count1 = 1) instead of hiding.
   *Alternatives rejected:* single `<Esc>` (breaks Esc for programs like PSReadLine, vim, fzf),
   `<C-h/j/k/l>` (clash with pwsh clear screen/backspace), Alt keys (Windows Terminal swallows some).
4. **Moving = a session-wide position for the panel.** A module-level `position` (`"bottom"` by
   default) is passed as `win.position` when a terminal is created. `<leader>tr`/`<leader>tb` set it,
   then for every terminal in `Snacks.terminal.list()`: remember whether it was visible, `hide()`, set
   `opts.position`, and `show()` again if it was visible. All terminals move together because they
   stack as one panel. Focus returns to the moved terminal if it had focus. The helper is local to
   `snacks.lua`, so nothing outside `plugins/` requires snacks.
   *Alternative:* `wincmd L`/`wincmd J` on the window. Rejected because snacks tracks the position
   itself and would put the terminal back on the next show.
   *To check during implementation:* that `snacks.win:show()` uses the updated `opts.position`. If it
   doesn't, close the window (not the buffer) and re-show it with the new opts.
5. **Sizes:** snacks' split defaults. Panel size is not in the spec, so it can be tuned after the user
   checks it in real Neovim without changing the spec.
6. **Shell options go in `lua/config/options.lua`'s standalone block**, using the values from
   `:h shell-powershell`, plus `-NoProfile` in `shellcmdflag`. The exe is `pwsh` if it is executable,
   else `powershell`.
   - The interactive terminal runs bare `vim.o.shell` (`pwsh`). That skips `shellcmdflag`, so the
     profile loads and the user gets their aliases and prompt.
   - `:!`/`system()` use `shellcmdflag`, which has `-NoProfile -NonInteractive`, so they are fast and
     print no prompt noise.
   - `exit $LastExitCode` in `shellredir`/`shellpipe` keeps exit codes intact.
   *Alternative:* set pwsh only through snacks' `terminal.shell`, leaving `vim.o.shell` as cmd.exe.
   This is less risky, but `:!dotnet build` and `:make` would still run in cmd, which is part of what
   the user wants fixed.

## Risks / Trade-offs

- [A plugin runs a cmd-specific string command through `system()`] → None of the current plugins do
  (lazy, mason, telescope and plenary spawn directly). The build gate covers startup. If one breaks,
  the fallback is decision 6's alternative.
- [oh-my-posh makes each new terminal slow to start] → Only paid once per terminal, because hiding
  keeps the process. `-NoProfile` can be added to the terminal later if it bothers the user.
- [Count is lost when lazy-loading on the first key press] → lazy.nvim calls the `keys` function within
  the same mapping, so `vim.v.count1` should hold. Check `2<leader>tt` before snacks has loaded during
  verification.
- [Terminal on the right next to the opencode panel] → They share the right side in two vertical
  splits. Acceptable, and the default is bottom.
- [The terminal id includes cwd] → After `:cd`, `<leader>tt` opens a new terminal for the new cwd. The
  old one keeps running and comes back on `:cd` back. This is snacks' default behaviour; it is
  documented in `AGENTS.md`, not changed.

## Migration Plan

Additive. Rollback = revert the commit. `lazy-lock.json` drops snacks on the next `:Lazy clean`.
