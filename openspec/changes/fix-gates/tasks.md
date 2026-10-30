# Tasks

## 1. Fix startup error

- [ ] 1.1 Change `vim.opt.clipboard` in `lua/keymaps/regular.lua` to `'unnamedplus'` and verify `pwsh ./gates.ps1 build` prints `BUILD_EXIT:0`
- [ ] 1.2 Verify `nvim --headless "+lua io.write(vim.o.clipboard)" +qa` prints `unnamedplus`

## 2. Formatting standard

- [ ] 2.1 Add `stylua.toml` (spaces, indent 2, column width 120) and verify `stylua --check init.lua lua` reads it (diff output uses 2-space indent)
- [ ] 2.2 Change the `format` target in `gates.ps1` to `stylua --check init.lua lua` and update the format bullet in `AGENTS.md` ## Gates; verify the gate still runs and reports `FORMAT_EXIT:<n>`
- [ ] 2.3 Run `stylua init.lua lua` once and verify `pwsh ./gates.ps1 format` prints `FORMAT_EXIT:0`
- [ ] 2.4 Re-run `pwsh ./gates.ps1 build` after formatting and verify `BUILD_EXIT:0`
- [ ] 2.5 Add `stylua.toml` to the directory tree in `AGENTS.md` and verify `pwsh ./gates.ps1 gates` prints `GATES_EXIT:0`

## Workflow follow-up

- Archive the change with `/opsx-archive` after review.
