# nvim

My Neovim config, for Windows and WSL (Fedora). It also works inside VSCode through vscode-neovim, with keymaps only. Also contains my pwsh and zsh profiles.

## Install

- **Windows:** clone to `%LOCALAPPDATA%\nvim`
- **WSL:** clone to `~/.config/nvim`, see [docs/wsl.md](docs/wsl.md)
- **Windows Terminal** (both): run `pwsh windows-terminal/install.ps1` from the repo on Windows. It adds
  the Neovim key bindings (Ctrl+ø zooms the terminal, Ctrl+æ toggles terminal mode) to Windows Terminal's
  `settings.json`, keeping everything else. From WSL: `pwsh.exe -ExecutionPolicy Bypass -File "$(wslpath -w
  windows-terminal/install.ps1)"` (Windows won't run an unsigned script from the WSL share otherwise). The
  live file is `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.

Required tools: [docs/dependencies.md](docs/dependencies.md). Keymaps and details: [AGENTS.md](AGENTS.md).
