# Design

## Context

`gates.ps1 build` runs `nvim --headless -u init.lua` and fails if `vim.v.errmsg` is set. Today it fails with `E474: Invalid argument` from `lua/keymaps/regular.lua`, which already had uncommitted edits (`'unnamedplus'` → `'unnamedpl|||us'`) before OpenSpec was added. `gates.ps1 format` currently passes `--indent-type Spaces --indent-width 2` on the command line. The files mix tabs and spaces.

## Goals / Non-Goals

**Goals:** all gates green; one formatter config used by both the gate and the editor.

**Non-Goals:** clearing the other items in the AGENTS.md "Known Issues" table (duplicate mappings, dead `lua/bru/` file, etc.). They go in later changes.

## Decisions

- **Fix the clipboard value rather than dropping it.** `unnamedplus` is the documented intent (AGENTS.md). The `|||` looks like an accidental edit. Alternative: revert the whole file with `git checkout`. Same result here, but an explicit edit is clearer in the section commit.
- **`stylua.toml` at the repo root** with `indent_type = "Spaces"`, `indent_width = 2`, `column_width = 120`, and StyLua defaults for everything else. The gate becomes `stylua --check init.lua lua`. Alternative: keep the CLI flags. Rejected, because an editor format-on-save wouldn't pick them up and would drift from the gate.
- **The formatting pass is its own section and commit**, separate from the bug fix. That keeps the one-line behaviour fix easy to find, and lets the formatting commit go into `.git-blame-ignore-revs` later if wanted.
- **Leave quote style at StyLua's default** (`AutoPreferDouble`). The files currently mix `'` and `"`, so any choice causes churn. The default needs no config.

## Risks / Trade-offs

- [Formatting changes behaviour] → StyLua is AST-preserving; the `build` gate re-runs after formatting to confirm startup is still clean.
- [Headless `build` may try to install/update plugins via lazy.nvim on a fresh machine and need network] → acceptable on this machine (plugins already installed); noted for the future.
