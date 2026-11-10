# Dependencies

Every tool this repo needs. `pwsh ./gates.ps1 deps` checks each row.

| Tool | Version | Why | Install | Check | Auth check |
|------|---------|-----|---------|-------|------------|
| Neovim | 0.12+ | The config itself; `build` gate (headless startup); nvim-treesitter's `main` branch needs 0.12 | `winget install Neovim.Neovim` (upgrade: `winget upgrade Neovim.Neovim`) | `nvim --version` (first line ≥ `NVIM v0.12`) | — |
| StyLua | 2.x | `format` gate (`stylua --check`) | `winget install JohnnyMorganz.StyLua` | `stylua --version` | — |
| Git | any | lazy.nvim plugin bootstrap, version control | `winget install Git.Git` | `git --version` | — |
| Node.js | 20+ | Runs the OpenSpec CLI | `winget install OpenJS.NodeJS.LTS` | `node --version` | — |
| OpenSpec CLI | 1.x | Change tracking, `validate` gate | `npm i -g @fission-ai/openspec` | `openspec --version` | — |
| PowerShell | 7+ | Runs `gates.ps1`; runtime shell for standalone Neovim (`:terminal`, `:!`, `system()`) | `winget install Microsoft.PowerShell` | `pwsh --version` | — |
| OpenCode CLI | 1.x or 2.x | Server behind the `opencode.nvim` panel (`<leader>o…` in standalone Neovim) | `npm i -g opencode-ai` | `opencode --version` | provider connected: run `opencode`, then `/connect` (manual) |
| ripgrep | any | snacks picker grep (`<leader>fa`/`<leader>fw` in standalone Neovim); files picker fallback when `fd` is missing | `winget install BurntSushi.ripgrep.MSVC` | `rg --version` | — |
| fd | any | snacks projects picker (`<leader>fP`, `p` on the start screen) scans for projects with it; the files picker (`<leader>ff`) prefers it over `rg` | `scoop install fd` | `fd --version` | — |
| lazygit | any | Git panel (`<leader>gg` in standalone Neovim, through snacks) | `winget install JesseDuffield.lazygit` | `lazygit --version` | — |
| tree-sitter CLI | 0.26.1+ | nvim-treesitter (`main`) builds the C#, XML, JSON, PowerShell and Python parsers with it | `scoop install tree-sitter` | `tree-sitter --version` (≥ 0.26.1) | — |
| C compiler (MSVC) | VS Build Tools with VC tools | The tree-sitter CLI compiles parsers with it (found through the VS installer; `cl` needn't be on `PATH`) | `winget install Microsoft.VisualStudio.2022.BuildTools`, with the "Desktop development with C++" workload | `vswhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64` prints a path | — |
