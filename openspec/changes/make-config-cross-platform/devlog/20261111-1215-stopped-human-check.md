# Stopped: §4 human check (4.3)

<!-- Section: 4 · Tasks: 4.1–4.4 · Base: 2aff58f -->

Waiting on the user to run the 4.3 recipe below. Work is **uncommitted on purpose**; 4.1 and 4.2 are done
but not ticked (section is stopped).

Done this session (uncommitted: `docs/wsl.md` new; `readme.md`, `docs/dependencies.md`, `gates.ps1`,
`gates.sh` modified):
- **4.1 `docs/wsl.md`**, linked from `readme.md` (line under the title). Built from the WSL machine's actual
  state (`/etc/wsl.conf`, `dnf repoquery --userinstalled`, `npm ls -g`, `dnf copr list`,
  `git config --global --list`, `~/.local/bin` links) plus what this change ran. Bash history only had the
  oh-my-posh commands, so earlier dnf/npm lines are reconstructed from installed state.
- **User's answers:** (1) Windows Terminal: **make Fedora the default profile**. Done:
  `settings.json` `defaultProfile` `{574e775e-…}` (PowerShell) → `{63ac7c31-2756-5417-9d9b-4330f2c3269a}`
  (`FedoraLinux-45`, from WSL's fragment in `%LOCALAPPDATA%\Microsoft\Windows Terminal\Fragments\Microsoft.WSL\`);
  backup at `%TEMP%\opencode\wt-settings.backup.json`. (2) **Install VSCode Remote-WSL**: installed
  `ms-vscode-remote.remote-wsl` v1.104.7; linked `code` into WSL `~/.local/bin` (needed with
  `appendWindowsPath=false`); `code --version` in WSL installed the VS Code Server, rc 0.
- **opencode install drift fixed:** both machines run `@opencode/cli` 2.x (`opencode-ai` latest is 1.19.5);
  `npm i -g opencode-ai` → `npm i -g @opencode/cli` in `dependencies.md`, `gates.ps1`, `gates.sh`.
- **4.2:** `git clone https://github.com/Egglis/nvim-config.git ~/.config/nvim` (at `2aff58f`), `~/.zshrc` →
  `~/.config/nvim/shell/.zshrc`, `sudo usermod -s /usr/bin/zsh egil` → `getent passwd` ends `/usr/bin/zsh`.
  In the clone: `./gates.sh deps` → `DEPS_EXIT:0`; `./gates.sh gates` (2nd run) → `BUILD_EXIT:0`
  `FORMAT_EXIT:0` `VALIDATE_EXIT:0` `GATES_EXIT:0`; `git status` clean; `nvim --headless "+Lazy! restore" +qa`
  rc 0, still clean. After `wsl --terminate`: `$SHELL=/usr/bin/zsh`, `nconfig` → `/home/egil/.config/nvim`,
  `POSH_CONFIG=…/ys.omp.json`, `phelp` 6 lines.
- Windows: `pwsh ./gates.ps1 gates` → `BUILD_EXIT:0` `FORMAT_EXIT:0` `VALIDATE_EXIT:0` `GATES_EXIT:0`;
  `pwsh ./gates.ps1 deps` → `DEPS_EXIT:0`.

Gotchas: the WSL clone at `~/.config/nvim` lacks this uncommitted work until the §4 commit is pushed
(then `git -C ~/.config/nvim pull`). `wsl.exe` output to pwsh is UTF-16 (spaced letters); harmless.

## Question: 4.3 recipe (human check)

Open a **new Windows Terminal tab** (should now be Fedora):
1. Prompt is oh-my-posh `ys`; `phelp` lists 6 aliases; `desk` → `/mnt/c/Users/EgilBru/Desktop`.
2. `nconfig && nvim` → start screen. `<leader>ff` finds files, `<leader>fa` greps.
3. Clipboard: `yy` a line in Neovim → paste in Notepad. Copy text in Notepad → `p` in Neovim.
4. `gx` on a URL (e.g. type `https://neovim.io`) and `<leader>go` on a file → Windows browser opens.
5. `:e scratch.txt`, `:w`, `<leader>fe`, cursor on it, `d`, confirm → in the terminal: `trash-list` shows it.
6. `<leader>tt` → zsh with the ys prompt; `phelp` works there.
7. Edit any file, `<leader>gg` → lazygit; on that file press `e` → it opens in this Neovim. `git checkout -- .` after.
8. A `.cs` file (e.g. `git clone` a small C# repo into `~`, or `dotnet new console -o ~/cstest`), open
   `Program.cs` → roslyn_ls attaches (`:checkhealth vim.lsp`) and highlighting is tree-sitter (`:Inspect`
   shows `@…` captures).
9. `:qa` with a file open, then `nvc` in the same folder → the session comes back.

On Windows:
10. A PowerShell 7 tab (WT dropdown), `nvim`, `<leader>tt` → pwsh with your profile.
11. VSCode on Windows → vscode-neovim starts (e.g. `<leader>ff` searches the file). Optional: `code .` from
    the Fedora tab opens via Remote-WSL.

Reply with PASS, or the numbers that failed and what you saw.

## Next

- On PASS: record the answers in a devlog note, tick 4.1–4.3, do 4.4 (tick the readme WSL TODO with a
  one-line summary), gates on both, section-done note, one §4 commit, push, `git -C ~/.config/nvim pull`
  in WSL, then the whole-change review.
- On FAIL: fix the failing items in this section (still uncommitted), rerun what's affected, ask for a
  re-check of those items.
