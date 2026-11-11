# Dependencies

Every tool this repo needs. `pwsh ./gates.ps1 deps` (Windows) and `./gates.sh deps` (Linux, incl. WSL) check
each row for their platform.

| Tool | Version | Platform | Why | Install (Windows) | Install (Fedora) | Check | Auth check |
|------|---------|----------|-----|-------------------|------------------|-------|------------|
| Neovim | 0.12+ | all | The config itself; `build` gate (headless startup); nvim-treesitter's `main` branch needs 0.12 | `winget install Neovim.Neovim` (upgrade: `winget upgrade Neovim.Neovim`) | `sudo dnf install neovim` | `nvim --version` (first line ≥ `NVIM v0.12`) | — |
| StyLua | 2.x | all | `format` gate (`stylua --check`) | `winget install JohnnyMorganz.StyLua` | `npm i -g @johnnymorganz/stylua-bin` | `stylua --version` | — |
| Git | any | all | lazy.nvim plugin bootstrap, version control | `winget install Git.Git` | `sudo dnf install git` | `git --version` | — |
| Node.js | 20+ | all | Runs the OpenSpec CLI | `winget install OpenJS.NodeJS.LTS` | `sudo dnf install nodejs npm`, then `npm config set prefix ~/.local` (global installs without sudo) | `node --version` | — |
| OpenSpec CLI | 1.x | all | Change tracking, `validate` gate | `npm i -g @fission-ai/openspec` | same | `openspec --version` | — |
| OpenCode CLI | 1.x or 2.x | all | Server behind the `opencode.nvim` panel (`<leader>o…` in standalone Neovim) | `npm i -g opencode-ai` | same | `opencode --version` | provider connected: run `opencode`, then `/connect` (manual, once per platform) |
| ripgrep | any | all | snacks picker grep (`<leader>fa`/`<leader>fw` in standalone Neovim); files picker fallback when `fd` is missing | `winget install BurntSushi.ripgrep.MSVC` | `sudo dnf install ripgrep` | `rg --version` | — |
| fd | any | all | snacks projects picker (`<leader>fP`, `p` on the start screen) scans for projects with it; the files picker (`<leader>ff`) prefers it over `rg` | `scoop install fd` | `sudo dnf install fd-find` | `fd --version` | — |
| lazygit | any | all | Git panel (`<leader>gg` in standalone Neovim, through snacks) | `winget install JesseDuffield.lazygit` | `sudo dnf copr enable atim/lazygit && sudo dnf install lazygit` (the COPR build is old, 0.47, but works) | `lazygit --version` | — |
| tree-sitter CLI | 0.26.1+ | all | nvim-treesitter (`main`) builds the C#, XML, JSON, PowerShell and Python parsers with it | `scoop install tree-sitter` | `sudo dnf install tree-sitter-cli` | `tree-sitter --version` (≥ 0.26.1) | — |
| PowerShell | 7+ | Windows | Runs `gates.ps1`; runtime shell for standalone Neovim on Windows (`:terminal`, `:!`, `system()`) | `winget install Microsoft.PowerShell` | — | `pwsh --version` | — |
| C compiler (MSVC) | VS Build Tools with VC tools | Windows | The tree-sitter CLI compiles parsers with it (found through the VS installer; `cl` needn't be on `PATH`) | `winget install Microsoft.VisualStudio.2022.BuildTools`, with the "Desktop development with C++" workload | — | `vswhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64` prints a path | — |
| gcc + make | any | Linux | The tree-sitter CLI compiles parsers with them | — | `sudo dnf install gcc make` | `gcc --version`, `make --version` | — |
| trash-cli | any | Linux | Explorer delete (`d` in `<leader>fe`) goes to the freedesktop trash; without a trash tool snacks deletes permanently | — | `sudo dnf install trash-cli` | `command -v trash` | — |
| zsh | 5.x | Linux | Login shell; runs `shell/.zshrc` (the aliases and prompt) and the terminal panel | — | `sudo dnf install zsh` | `zsh --version` | — |
| oh-my-posh | any | Linux | Prompt in `shell/.zshrc` (Windows: installed separately for the pwsh profile) | — | `sudo dnf install gawk unzip`, then `curl -s https://ohmyposh.dev/install.sh \| bash -s -- -d ~/.local/bin` (the installer needs `awk`, which the Fedora WSL image lacks; themes go to `~/.cache/oh-my-posh/themes`) | `oh-my-posh --version` | — |
| win32yank | any | WSL | The `+`/`*` registers use the Windows clipboard through it | — (ships with Windows Neovim) | `ln -s "/mnt/c/Program Files/Neovim/bin/win32yank.exe" ~/.local/bin/` | `command -v win32yank.exe` | — |
