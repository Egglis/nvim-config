# Tasks

## 1. pwsh as Neovim's shell

- [x] 1.1 In `lua/config/options.lua`'s standalone block, set `shell` (`pwsh`, else `powershell`), `shellcmdflag` (`:h shell-powershell` flags plus `-NoProfile`), `shellredir`, `shellpipe`, `shellquote=""` and `shellxquote=""` (design decision 6). Verify headless: `nvim --headless "+lua io.write(vim.o.shell, ' ', tostring(vim.o.shellcmdflag:find('-NoProfile', 1, true) ~= nil))" +q` prints `pwsh true`
- [x] 1.2 Check the `editor-options` scenarios headless: `vim.fn.system('$PSVersionTable.PSVersion.Major')` returns `7` with no oh-my-posh output; `vim.fn.system('exit 3')` leaves `vim.v.shell_error == 3`; with `--cmd "let g:vscode=1"`, `shell` is still Neovim's default
- [x] 1.3 Docs: add `shell` to the "Standalone only" line of the Options section in `AGENTS.md`, and add "runtime shell for standalone Neovim" to the PowerShell row's "Why" in `docs/dependencies.md`. `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 2. Snacks terminal

- [x] 2.1 Create `lua/plugins/snacks.lua`: `folke/snacks.nvim`, `opts = { terminal = {} }` (no other module enabled), lazy-loaded through `keys` for `<leader>tt`, `<leader>tr` and `<leader>tb` (normal mode, each with a `desc`). `<leader>tt` calls `Snacks.terminal.focus(nil, { win = { position = position } })` (design decisions 1 and 2)
- [x] 2.2 Add the local move helper for `<leader>tr`/`<leader>tb`: set the session `position`, then hide and re-show every terminal in `Snacks.terminal.list()` at that position, keeping focus where it was (design decision 4, including the `show()`/`opts.position` check)
- [x] 2.3 Install snacks (`:Lazy sync` headless) and commit the updated `lazy-lock.json`. Verify headless that startup does not load snacks (`package.loaded.snacks == nil` after `VimEnter`), and that every config mapping still has a `desc`
- [x] 2.4 Docs: `AGENTS.md`, including the plugin table row, the directory tree entry, and a "Terminal" keymap section (`<leader>tt` / `N<leader>tt`, `<leader>tr`, `<leader>tb`, double `<Esc>`, `q`, and the one-terminal-per-cwd note). Tick the readme TODO "Terminal plugin for running scripts and projects". `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 3. Ctrl+t toggle

- [x] 3.1 In `lua/plugins/snacks.lua`, add a local toggle: with no count and the current buffer a snacks terminal, hide that terminal; otherwise `Snacks.terminal.focus(nil, { win = { position = position } })`. Use it for `<leader>tt` (n) and a new `<C-t>` (n and t, with a `desc`) (design decision 3)
- [x] 3.2 Docs: `AGENTS.md` Terminal section (`<C-t>` row, note that it replaces Vim's tag-pop `<C-t>`) and the plugin table row's key list. `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 4. Human verification

- [x] 4.1 User checks in real Neovim (Windows Terminal), following a recipe the agent provides:
  - `<leader>tt` opens pwsh at the bottom, with the oh-my-posh prompt and `nconfig` working.
  - `dotnet --version` runs.
  - Start `dotnet watch` (or `ping -t localhost`), hide with `q`, and reopen with `<leader>tt`: the process is still running.
  - `<leader>tr` and `<leader>tb` move it, and the position is remembered after hide/reopen.
  - `2<leader>tt` opens a second terminal, including as the first key press after startup.
  - Double `<Esc>` reaches normal mode, and a single `<Esc>` still reaches the program.
  - `<C-t>` while typing in the terminal hides it (also in terminal 2); `<C-t>` from the editor reopens it.
  - `:!dotnet --version` runs through pwsh without the prompt.
  - `<leader>tt` inside VSCode still toggles VSCode's terminal.
  - The panel sizes look right.
