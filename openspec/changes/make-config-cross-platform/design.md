# Design

## Context

See `proposal.md` for the why. The current state:

- `lua/config/options.lua` sets pwsh and the `:h shell-powershell` flags inside `if not vim.g.vscode`, with no
  platform check. On Linux, `pwsh` isn't installed, so the fallback `powershell` becomes `shell` and `:!`,
  `system()` and the terminal panel break.
- Everything else is already portable or checks the platform: `lazygit_os()` in `plugins/snacks.lua` uses
  snacks' `nvim-remote` preset off Windows, `<leader>ns` uses `~/.microsoft/usersecrets` off Windows,
  `repo_accent`, treesitter and the LSP servers use `vim.fs` paths, and snacks' explorer trash tries
  `trash` (trash-cli), then `gio trash`, then KDE, and **deletes permanently if none is found**.
- Fedora 45 in WSL (`FedoraLinux-45`, WSL 3.0.5) is set up with every Linux tool. `appendWindowsPath=false`
  is set, so Windows binaries are reached only by absolute path or through links in `~/.local/bin`
  (`win32yank.exe` and `explorer.exe` are linked there today). `wl-clipboard` and `xdg-utils` were pulled in
  as weak dependencies. `wslu` has no Fedora 45 build.
- Neovim 0.12's clipboard detection tries `wl-copy` (when `$WAYLAND_DISPLAY` is set, and WSLg sets it)
  before `win32yank`. `vim.ui.open` tries `xdg-open` before `wslview` and `explorer.exe`, and `xdg-open`
  with no desktop falls back to `$BROWSER`, which is unset.
- `gates.ps1 build` runs `nvim -u init.lua` from the repo. That works on Windows because the repo **is**
  `stdpath("config")`. A Linux checkout might not be (e.g. testing from `/mnt/c/...`), and then `require`
  wouldn't find `lua/`.
- The working tree has uncommitted work that isn't part of any change (sessions: `lua/config/session.lua`,
  `init.lua`, `snacks.lua`, the pwsh profile, `AGENTS.md`, `readme.md`). It must be committed or set aside
  before this change starts (AGENTS.md: clean tree).

## Goals / Non-Goals

**Goals:**
- One repo, one `master`, checked out on Windows (`%LOCALAPPDATA%\nvim`) and in WSL (`~/.config/nvim`),
  behaving the same apart from the documented platform differences.
- Platform checks stay in a few obvious places (mainly `options.lua`), so no plugin spec branches on the
  OS.
- Windows behaviour doesn't change: same shell, same gates, same profile.

**Non-Goals:**
- macOS.
- Making Windows Neovim edit files inside WSL, or WSL Neovim edit `/mnt/c` projects fast. The user's repos
  move into WSL, and the config doesn't try to cover the cross-boundary case.
- Changing Neovim's choices on native Linux (clipboard, URL opener). Overrides apply only under `has("wsl")`.

## Decisions

### D1. Platform detection: `has("win32")` and `has("wsl")`, nothing else
`vim.fn.has("win32")` decides the shell. `vim.fn.has("wsl")` decides the WSL-only clipboard and URL opener.
There's no helper module: there are three checks, all in `options.lua`, and the code already reads
`has("win32")` inline (`regular.lua`, `snacks.lua`).
*Alternative:* a `config/platform.lua` with `is_windows`/`is_wsl`. Not worth a module for three
booleans.

### D2. Shell: the pwsh block runs only on Windows; Linux keeps Neovim's defaults
Wrap the existing `shell`/`shellcmdflag`/`shellredir`/`shellpipe`/`shellquote`/`shellxquote` block in
`if vim.fn.has("win32") == 1`. On Linux, Neovim's defaults use `$SHELL` (zsh) with `-c`. The terminal panel
uses `vim.o.shell`, so it picks this up with no change to snacks.
*Alternative:* force `/bin/bash` for `:!` speed. zsh `-c` doesn't read `.zshrc` (only `.zshenv`), so the
default is already fast and keeps the user's shell.

### D3. WSL clipboard: set `g:clipboard` to win32yank explicitly
Under `has("wsl")`, and when `win32yank.exe` is executable, set `vim.g.clipboard` to win32yank (Neovim's
built-in `"win32yank"` provider name if 0.12 accepts a string, otherwise an explicit table:
`win32yank.exe -i --crlf` to copy, `win32yank.exe -o --lf` to paste, `cache_enabled = 0`). This must be set
before the first clipboard use, which holds because `options.lua` runs first. When win32yank is missing,
`g:clipboard` is left alone and Neovim chooses (spec: no startup error).
*Alternatives:* `wl-copy` through WSLg (Neovim's own pick, but WSLg's clipboard bridge is known to drop or
lag updates), OSC 52 (Windows Terminal supports copy only, and paste hangs waiting for a reply), and
`clip.exe` with `powershell Get-Clipboard` (paste starts PowerShell, ~0.3–0.5 s).

### D4. WSL URL opener: wrap `vim.ui.open` to call `explorer.exe`, always exiting 0
Under `has("wsl")`, and only when no `wslview` is executable, replace `vim.ui.open` with a wrapper that
calls the original with `opt.cmd` set to a small `sh -c` launcher. The launcher converts a non-URL path with
`wslpath -w`, runs `/mnt/c/Windows/explorer.exe "$1"`, and `exit 0`. `explorer.exe` exits 1 even when it
succeeds, which `gx` would report as an error. `gx`, `:Open` and snacks' `<leader>go` all go through
`vim.ui.open`, so one override covers them. Using the absolute path works without `appendWindowsPath` or the
`~/.local/bin` link.
*Alternatives:* `$BROWSER=explorer.exe` (depends on how `xdg-open` handles a non-zero exit, and only applies
if Neovim was started from a shell that set it), `wslview` (no Fedora 45 build), `cmd.exe /c start` (warns
about UNC paths when the cwd is in the WSL filesystem), and `powershell.exe Start-Process` (slow).

### D5. Explorer trash: no config change, enforced as a dependency
snacks already tries `trash` first, and trash-cli is installed on Fedora. The only risk is snacks' silent
fallback to permanent delete, so `gates.sh deps` requires `trash`. The Windows path (PowerShell Recycle
Bin) is unchanged.

### D6. `gates.sh`: a bash mirror of `gates.ps1`, config root made explicit
The same targets, `LABEL_EXIT:<n>` lines and exit codes (unknown target → 2). `gates` runs every gate
without stopping. The build gate runs with `XDG_CONFIG_HOME=<repo parent>` and
`NVIM_APPNAME=<repo folder name>`, so `stdpath("config")` is the checkout wherever it lives. In
`~/.config/nvim` this changes nothing, and from `/mnt/c/.../nvim` it still loads that checkout's `lua/`.
`deps` prints `MISSING <tool> — <dnf/npm/curl command>`. Versions are compared with `sort -V`. The
`win32yank.exe` check runs only when `/proc/sys/fs/binfmt_misc/WSLInterop` exists or
`$WSL_DISTRO_NAME` is set. `gates.sh` starts with `set -u` but not `-e` (gates must keep going after a
failure).
*Alternative:* pwsh in WSL with one `gates.ps1` (rejected by the user: no Microsoft repo, no pwsh in WSL).
Cost: two scripts to keep in step, so AGENTS.md gets a rule that a gate change lands in both.

### D7. zsh profile: repo file linked to `~/.zshrc`, lazy Windows-folder lookup
`shell/.zshrc` contains:
- `~/.local/bin` on `PATH`, `EDITOR=nvim`, history settings, and `compinit`.
- The aliases. Most become functions, which is how the pwsh profile defines them too.
- oh-my-posh: `oh-my-posh init zsh --config <themes dir>/ys.omp.json`, guarded by `command -v oh-my-posh`
  and a check that the theme file exists, otherwise oh-my-posh's default theme.

`desk`/`doc` in WSL find the Windows profile folder on first use only:
`/mnt/c/Windows/System32/cmd.exe /c 'echo %USERPROFILE%'` run from `/mnt/c` (avoiding the UNC warning),
converted with `wslpath`, and cached in a shell variable. No Windows process starts at shell startup (spec).
*Alternatives:* compute it at startup (≈50–100 ms on every shell), or hard-code `/mnt/c/Users/EgilBru`
(breaks on the home PC).

### D8. Line endings and the exec bit
`.gitattributes` adds `*.sh text eol=lf` and `shell/.zshrc text eol=lf`, and `gates.sh` is committed with
`git update-index --chmod=+x`. Lua is already `eol=lf`. The WSL clone uses `core.autocrlf=input` (already
set globally there).

### D9. Docs
`docs/dependencies.md` keeps one table, with the Install column split into Windows and Fedora, and a
Platform column (`all`/`Windows`/`Linux`/`WSL`). The new rows are gcc+make (Linux), trash-cli (Linux), zsh
and oh-my-posh (Linux), and win32yank (WSL). MSVC and pwsh become Windows-only. `docs/wsl.md` is a
replayable setup guide covering:
- WSL ≥ 2.5.7 (`wsl --update`, elevated), installing Fedora, and `appendWindowsPath=false`.
- The dnf/COPR/npm installs and oh-my-posh.
- git through the Windows Credential Manager.
- Cloning to `~/.config/nvim`, `ln -s ~/.config/nvim/shell/.zshrc ~/.zshrc`, and
  `sudo usermod -s /usr/bin/zsh $USER`.
- The Windows Terminal profile and VSCode Remote-WSL.

`AGENTS.md` gets the platform notes and the Linux gate commands.

## Risks / Trade-offs

- [Neovim 0.12 might not accept `g:clipboard = "win32yank"` as a string] → use the explicit table (D3), and
  confirm with `:checkhealth vim.provider` in WSL.
- [Overriding `vim.ui.open` could break callers that pass their own `opt.cmd`] → the wrapper only sets
  `opt.cmd` when the caller didn't.
- [`gates.sh` and `gates.ps1` drift apart] → an AGENTS.md rule, and both define the same target list at the
  top so a diff shows gaps.
- [lazygit 0.47 from COPR is old] → it works with snacks' float and the `nvim-remote` preset. Replacing it
  is out of scope, noted in `docs/dependencies.md`.
- [First `./gates.sh build` in WSL installs plugins and compiles parsers, needing network and taking a while]
  → expected once. The gate measures startup errors, not speed.
- [Session files from Windows (`c%%users%...`) and WSL (`%home%egil%...`) are separate] → by design. A
  project only exists on one side after the move.

## Migration Plan

1. Land the change on `master` from the Windows checkout (gates green on Windows, and on Linux from
   `/mnt/c/...` via `wsl -d FedoraLinux-45`).
2. In WSL: `git clone` to `~/.config/nvim`, link `~/.zshrc`, switch the login shell to zsh, install
   oh-my-posh, then `./gates.sh deps` and `./gates.sh gates`. The first Neovim start installs plugins.
3. Human check in WSL: clipboard both ways, `gx`/`<leader>go`, explorer delete into the trash, terminal
   panel running zsh with the aliases, lazygit `e`.
4. Rollback: nothing on Windows changes, and the WSL side can be deleted (`~/.config/nvim`, `~/.zshrc`).

## Open Questions

- ~~Where oh-my-posh's installer puts themes on Linux~~ Resolved in §3: `~/.cache/oh-my-posh/themes` (the
  installer's default; it needs `awk`, so `gawk` is part of the Fedora install command).
