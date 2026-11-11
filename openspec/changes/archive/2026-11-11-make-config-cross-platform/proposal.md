# Proposal

## Why

The readme TODO "Move everything to WSL 2.0 instead, make it cross compatible!" is open. The user is moving
daily Neovim and coding work into WSL 2 (Fedora 45, the same distro as the home PC), but this config assumes
Windows: it forces pwsh as the shell, the gates and dependency check are pwsh-only with winget/MSVC checks,
and the shell profile exists only for PowerShell. Fedora 45 is already installed and set up on this PC (see
Impact), so the config is the remaining blocker. It must keep working on Windows, because the Windows
checkout and VSCode mode stay in use during and after the move.

## What Changes

- **Shell per platform.** On Windows, standalone Neovim keeps pwsh with today's flags. On Linux (WSL or
  native), it leaves `shell` at Neovim's default (the login shell, zsh) with the default flags.
- **WSL clipboard.** Inside WSL, `"+`/`"*` go through `win32yank.exe` to the Windows clipboard, set
  explicitly so Neovim doesn't choose `wl-clipboard` over WSLg (a known flaky bridge). Native Linux and
  Windows keep Neovim's own provider choice.
- **WSL browser.** Inside WSL, opening a URL (`<leader>go`, `gx`, `:Open`) opens it in the Windows default
  browser. `wslu`/`wslview` has no Fedora 45 build, so this goes through `explorer.exe`.
- **Explorer delete goes to the system trash on every platform**: the Recycle Bin on Windows, the
  freedesktop trash (`trash-cli`) on Linux. Without a trash tool, snacks would delete permanently, so the
  deps check requires one.
- **Gates on Linux.** A new `gates.sh` (bash) with the same targets and `LABEL_EXIT:<n>` lines as
  `gates.ps1` (`build`, `format`, `validate`, `gates`, `changes`, `deps`). Its `deps` target checks the
  Fedora toolchain (gcc instead of MSVC, plus `win32yank.exe` inside WSL, and `trash`). `gates.ps1` is
  unchanged on Windows.
- **zsh profile.** A new `shell/.zshrc` in the repo, linked from `~/.zshrc`. It has the pwsh profile's
  aliases (`nconfig`, `nvc`, `nvimf`, `desk`, `doc`, `phelp`) and the same oh-my-posh `ys` prompt. Inside
  WSL, `desk`/`doc` go to the Windows Desktop/Documents. `sprofile` isn't needed on Linux, because the link
  makes the repo file the live profile.
- **Docs.** `docs/dependencies.md` gets a Fedora install column and Linux checks. A new `docs/wsl.md`
  records the WSL setup steps so the home PC (and a rebuilt work PC) can repeat them. `AGENTS.md` gets
  cross-platform notes and the readme TODO is ticked.
- `.gitattributes`: `*.sh` and the zsh profile are always LF, so they run from either checkout.

Out of scope: VSCode Remote-WSL setup (a note in `docs/wsl.md`, no config change; `vscode.lua` is
unchanged), macOS, moving the user's repos into WSL, the uncommitted sessions work (`lua/config/session.lua`
and friends), and replacing the old lazygit 0.47 COPR build.

## Capabilities

### New Capabilities
- `shell-profile`: the user's shell profiles kept in this repo (PowerShell on Windows, zsh on Linux): the
  same aliases and prompt on both, and how each is installed.

### Modified Capabilities
- `editor-options`: "Shell is PowerShell 7" becomes a per-platform shell requirement. New requirements: the
  WSL clipboard goes through `win32yank`, and WSL opens URLs in the Windows browser.
- `config-health`: the gates and the dependency check run on both Windows (`gates.ps1`) and Linux
  (`gates.sh`) with the same targets and exit lines. The 0.12 version check applies to both.
- `file-explorer`: delete goes to the platform's system trash (the Recycle Bin on Windows, the freedesktop
  trash on Linux), never a permanent delete.
- `terminal`: the panel runs the platform's configured shell (pwsh on Windows, the login shell on Linux), no
  longer pwsh everywhere.
- `git`: `<leader>go` opens the remote page in the Windows browser when Neovim runs in WSL.

## Impact

- Changed: `lua/config/options.lua` (shell guard, WSL clipboard and browser), `.gitattributes`.
  `gates.ps1` is unchanged.
- New: `gates.sh`, `shell/.zshrc`, `docs/wsl.md`.
- Docs: `docs/dependencies.md`, `AGENTS.md`, `readme.md`.
- No new Neovim plugin; `lazy-lock.json` is unchanged.
- New Linux dependencies (already installed on this PC's Fedora 45 in WSL): neovim, git, ripgrep,
  fd-find, tree-sitter-cli, gcc, make, nodejs/npm (global prefix `~/.local`), opencode, openspec, stylua
  (npm `@johnnymorganz/stylua-bin`), lazygit (COPR `atim/lazygit`), trash-cli, zsh, oh-my-posh, .NET SDK
  10, and `win32yank.exe` on `PATH` inside WSL.
- Machine setup that isn't in the repo (recorded in `docs/wsl.md`): WSL ≥ 2.5.7 (Fedora 45 won't boot on
  2.4.x), `appendWindowsPath=false` in `/etc/wsl.conf`, git using Windows' Credential Manager.
