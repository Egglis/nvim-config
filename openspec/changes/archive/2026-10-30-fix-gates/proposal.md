# Proposal

## Why

The newly added gates (`pwsh ./gates.ps1 gates`) are red. Neovim fails to start: `lua/keymaps/regular.lua` sets `vim.opt.clipboard = 'unnamedpl|||us'`, which is an invalid value (E474) and aborts loading of the regular keymaps and lazy.nvim. Also, no Lua file matches the StyLua formatting standard, so the format gate fails as well. The workflow can't be relied on until both gates are green.

## What Changes

- Fix the invalid `clipboard` value in `lua/keymaps/regular.lua` (back to `unnamedplus`) so standalone Neovim starts cleanly again.
- Add a `stylua.toml` at the repo root that holds the formatting standard (2-space indent, matching `tabstop`/`shiftwidth`). `gates.ps1` and `AGENTS.md` then use it instead of repeating CLI flags.
- Run StyLua once over `init.lua` and `lua/` (a formatting-only change, with no change to behaviour).
- `validate` goes green because this change exists.

## Capabilities

### New Capabilities
- `config-health`: the configuration starts without errors and its Lua source follows one formatting standard, both checkable without a human.

### Modified Capabilities

## Impact

- `lua/keymaps/regular.lua`: one-line bug fix.
- Every `.lua` file under `init.lua` and `lua/`: whitespace/quote formatting only.
- New `stylua.toml`; `gates.ps1` `format` target and `AGENTS.md` gate description simplified.
- Large formatting diff makes `git blame` noisier for these files (a one-off cost).
