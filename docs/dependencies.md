# Dependencies

Every tool this repo needs. `pwsh ./gates.ps1 deps` checks each row.

| Tool | Version | Why | Install | Check | Auth check |
|------|---------|-----|---------|-------|------------|
| Neovim | 0.11+ | The config itself; `build` gate (headless startup) | `winget install Neovim.Neovim` | `nvim --version` | — |
| StyLua | 2.x | `format` gate (`stylua --check`) | `winget install JohnnyMorganz.StyLua` | `stylua --version` | — |
| Git | any | lazy.nvim plugin bootstrap, version control | `winget install Git.Git` | `git --version` | — |
| Node.js | 20+ | Runs the OpenSpec CLI | `winget install OpenJS.NodeJS.LTS` | `node --version` | — |
| OpenSpec CLI | 1.x | Change tracking, `validate` gate | `npm i -g @fission-ai/openspec` | `openspec --version` | — |
| PowerShell | 7+ | Runs `gates.ps1`; runtime shell for standalone Neovim (`:terminal`, `:!`, `system()`) | `winget install Microsoft.PowerShell` | `pwsh --version` | — |
| OpenCode CLI | 1.x or 2.x | Server behind the `opencode.nvim` panel (`<leader>o…` in standalone Neovim) | `npm i -g opencode-ai` | `opencode --version` | provider connected: run `opencode`, then `/connect` (manual) |
| ripgrep | any | snacks picker grep (`<leader>fa`/`<leader>fw` in standalone Neovim); files picker fallback when `fd` is missing | `winget install BurntSushi.ripgrep.MSVC` | `rg --version` | — |
| fd | any | snacks projects picker (`<leader>fP`, `p` on the start screen) scans for projects with it; the files picker (`<leader>ff`) prefers it over `rg` | `scoop install fd` | `fd --version` | — |
