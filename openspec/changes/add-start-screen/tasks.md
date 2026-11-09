# Tasks

## 1. Load snacks on a plain start

- [x] 1.1 In `lua/plugins/snacks.lua`, set `lazy = vim.fn.argc(-1) > 0` on the spec (design decision 1). Verify: `nvim --headless "+lua io.stdout:write(tostring(package.loaded.snacks ~= nil))" +qa` prints `true`, and the same with `init.lua` as a file argument prints `false`; `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`
- [x] 1.2 Docs: in `AGENTS.md`, update the Pickers and Terminal intros and the snacks plugin-table row to say snacks loads at startup only on a plain `nvim` (start screen) and stays lazy when a file or folder is given. Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 2. Start screen

- [ ] 2.1 Add `opts.dashboard` with explicit `sections`: the header function section (design decision 3), the menu entries `f g r p n c L q` (decision 4, with `c` and `p` sharing an `open_project(dir)` helper per decision 6), recent files (`limit = 5`, `cwd` = repo root or nil, decision 5), projects (`limit = 10`, `action = open_project`) and the startup line. Check `repo_accent.state` covers what the header needs; change `repo_accent.lua` only if it doesn't. Verify: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`, and a headless run with no arguments reports `Snacks.config.dashboard.enabled` true without errors
- [ ] 2.2 Docs: add a "Start screen — `lua/plugins/snacks.lua`" section to `AGENTS.md` (when it shows, header, the menu-key table, recent files/projects and their number/letter keys, that `c`/`p` do a global `:cd`), and mention the dashboard in the snacks plugin-table row. In `readme.md`, leave "Other UI improvements" unticked and add a sub-bullet noting the start screen is done. Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 3. Human verification

- [ ] 3.1 User checks in real Neovim, following a recipe the agent provides:
  - `nvim` in this repo: the start screen shows, the header is the repo name in its accent color, recent files are only from this repo, and up to 10 projects are listed.
  - `nvim` from `~`: the header is "Neovim" in the normal color and recent files are global.
  - `f`, `g`, `r`, `p` open the same pickers as `<leader>ff/fa/fr/fP`; `n` gives an empty buffer in insert mode; `L` opens Lazy; `q` quits.
  - `c` and confirming a project: the cwd changes, the top bar/statusline accent follows, and the file picker opens.
  - Number keys open entries; `j`/`k` move and `<CR>` opens; no entry uses `h j k l q` or a menu key.
  - `nvim init.lua` and `nvim .`: no start screen, opened as before; `<leader>ff` still loads the picker on first use.
  - `<leader>tt` from the start screen opens a terminal normally (no shell existed before).
  - Inside VSCode: no change.
