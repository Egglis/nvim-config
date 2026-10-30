## 1. Dependency

- [x] 1.1 Add an `opencode` row to `docs/dependencies.md` (install, `opencode --version` check, auth = provider connected via `/connect`)
- [x] 1.2 Add the matching `Check` to the `deps` target in `gates.ps1` and confirm `DEPS_EXIT:0`

## 2. Plugin spec

- [x] 2.1 Create `lua/plugins/opencode.lua`: `sudo-tee/opencode.nvim`, lazy-loaded via `cmd = 'Opencode'` and `keys` for `<leader>og`, `<leader>oi`, `<leader>oI` (each with `desc`)
- [x] 2.2 `opts`: `preferred_picker = 'telescope'`, `lock_session_to_directory = true`, `ui.position = 'right'`, `ui.window_width = 0.40`; default global keymaps kept
- [x] 2.3 Dependencies: `hrsh7th/nvim-cmp`, `nvim-telescope/telescope.nvim`, and `MeanderingProgrammer/render-markdown.nvim` (`ft = { 'markdown', 'opencode_output' }`, `anti_conceal = { enabled = false }`)
- [x] 2.4 Install plugins, commit updated `lazy-lock.json`; `pwsh ./gates.ps1 gates` green (startup clean, plugin not loaded at startup)

## 3. Docs

- [x] 3.1 `AGENTS.md`: add the two plugins to the plugin table and directory tree, and an "OpenCode" keymap section (`<leader>og`, `<leader>oi`, `<leader>oI`, `<leader>os`, `<leader>od`, plus a pointer to the plugin's full list)

## 4. Human verification

- [x] 4.1 User checks in real Neovim: `<leader>og` opens the panel on the right and toggles it without losing the conversation; `<leader>oI` starts a new session in the current cwd with the prompt focused; `:checkhealth opencode` is clean
