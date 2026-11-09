# Tasks

## 1. lazygit panel

- [ ] 1.1 Install lazygit (`winget install JesseDuffield.lazygit`, design decision 4). Add its row to `docs/dependencies.md` (Why: `<leader>gg` git panel in standalone Neovim; Check: `lazygit --version`) and its `Check` line to the `deps` target in `gates.ps1`. Verify: in a new `pwsh` process, `pwsh ./gates.ps1 deps` → `DEPS_EXIT:0`
- [ ] 1.2 In `lua/plugins/snacks.lua`, add the `<leader>gg` key (`Snacks.lazygit()`, decision 2) and `opts.lazygit` with the Windows-only pwsh `edit`/`editAtLine` override and `editInTerminal = false` (decision 3). Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`; a headless run that calls `Snacks.lazygit` setup (or opens and closes it) writes `stdpath("cache")/lazygit-theme.yml`, and that file has `editPreset` cleared and the `edit`/`editAtLine` lines with `$env:NVIM` and no `%`; `maparg("<leader>gg", "n")` is set after snacks loads
- [ ] 1.3 Docs: add a "Git — `lua/plugins/snacks.lua`" section to `AGENTS.md` with `<leader>gg` (lazygit float, `q` quits, `e` opens the file in this Neovim and hides the float, the next `<leader>gg` returns to the same session, `<C-t>` inside lazygit toggles the terminal instead), and add lazygit/`<leader>g…` to the snacks plugin-table row. Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 2. Git lookup keys

- [ ] 2.1 Add `<leader>gs`, `<leader>gl`, `<leader>gf`, `<leader>gb`, `<leader>gB`, `<leader>go` to the snacks `keys` with `desc`s (decision 2). Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`; headless in this repo, each key's function runs without a Lua error (pickers closed straight after); headless with cwd set to an empty temp folder, `Snacks.picker.git_log()` raises no Lua error; `<leader>fg` still maps to `git_status`
- [ ] 2.2 Docs: extend the `AGENTS.md` Git section with a table of the lookup keys (incl. `<Tab>`/`<C-r>` in status and `<CR>`/`<C-a>`/`<C-x>` in branches) and note that `<leader>gd/gr/gi` stay LSP keys; in the Pickers note, mention that `<leader>g…` is git here and LSP/VSCode-references elsewhere. In `readme.md`, tick "Git tree/sidebar for simple git actions". Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 3. Human verification

- [ ] 3.1 User checks in real Neovim, following a recipe the agent provides:
  - `nvim init.lua` in this repo, `<leader>gg`: lazygit opens in a float with tokyonight colors and readable icons; `q` closes it and the cursor is back in `init.lua`.
  - In lazygit, `e` on a changed file: the file opens in this Neovim (not a nested one) and the float is gone; `<leader>gg` again shows the same lazygit session.
  - In lazygit's staging view, `e` on a line: the file opens at that line.
  - A double `<Esc>` inside lazygit: note whether it leaves lazygit's input (design risk); no fix needed unless it bothers the user.
  - `<leader>gs` stages with `<Tab>`; `<leader>gl` and `<leader>gf` list commits with diffs; `<leader>gb` lists branches; `<leader>gB` shows the line's commit; `<leader>go` opens the file on GitHub.
  - In a buffer with LSP, `<leader>gd/gr/gi` still work and open without delay.
  - `:cd ~` then `<leader>gl` and `<leader>gg`: no Lua error.
  - Inside VSCode: `<leader>gr` is still Go to References; no change elsewhere.
