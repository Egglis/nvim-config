# Stopped: Neovim upgrade is a user step (1.3)

<!-- Section: 1 · Tasks: 1.1–1.2 done, 1.3 waiting · Base: 014df00 -->

- 1.2: the `deps` gate's `nvim` check now parses the first line of `nvim --version` and throws below
  0.12. The parse was checked on `NVIM v0.12.6` (ok), `NVIM v0.11.0` (fails), and
  `NVIM v0.13.0-dev-123+gabc` (ok). On this machine: `MISSING nvim 0.12+ - winget upgrade Neovim.Neovim`
  / `DEPS_EXIT:1`, as expected. `docs/dependencies.md` Neovim row: `0.12+`.
- Gotcha: this agent's shell had a stale PATH, so lazygit looked missing. Refreshing `$env:Path` from
  Machine+User fixed it, and lazygit is installed fine.
- 18 `nvim.exe` processes are running: several TUI sessions with their `--embed` children, plus two
  vscode-neovim ones (`--embed --cmd … vscode-neovim.vim`). Each holds `C:\Program Files\Neovim\bin\nvim.exe`
  open, so the MSI upgrade can't replace it until they're closed. This opencode session is not inside
  Neovim (`opencode.exe` → `pwsh`), so the upgrade doesn't end it.

Uncommitted: `gates.ps1`, `docs/dependencies.md`, the tasks.md ticks for 1.1–1.2, and the devlog notes.
The section commit comes after 1.6.

Question to the user: close every Neovim (terminal tabs and VSCode windows) and run
`winget upgrade Neovim.Neovim` (UAC prompt), then say when it's done.

## Next

- When the user confirms: refresh `$env:Path` from Machine+User, then check `nvim --version` →
  `NVIM v0.12.x` and `pwsh ./gates.ps1 deps` → `DEPS_EXIT:0`. Tick 1.3.
- Then 1.4: build gate plus headless checks of LSP/snacks/lualine/opencode on 0.12; update only a
  failing plugin.
- 1.5: shell checks (`:!$PSVersionTable.PSVersion.Major`, `system("exit 3")`, `:%!sort`).
- 1.6: AGENTS.md "Neovim 0.11" mentions; gates; then the section-done note and the commit
  `feat(faster-scrolling): Neovim 0.12 (§1)`.
