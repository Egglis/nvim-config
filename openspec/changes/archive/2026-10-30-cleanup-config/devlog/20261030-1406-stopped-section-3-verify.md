# Stopped: §3 waiting for VSCode verification

<!-- Section: 3 · Tasks: 3.1–3.5 · Base: b26e920 -->

The §3 work is implemented and uncommitted; tasks are unticked.

- 3.1 `lua/keymaps/vscode.lua` uses local `action(cmd)`/`map(modes, lhs, cmd, desc)` helpers, groups mappings under headings, and creates the Harpoon `h1`–`h9` mappings in a loop. Keys, modes and commands are the same as before; only the duplicate `<leader>fa` is gone (removed in §1).
- 3.2 `shared.lua`:
  - Every mapping has a `desc`.
  - `<C-s>` → `<cmd>w<CR>`.
  - `<Esc>` → `<cmd>nohlsearch<CR><Esc>`.
  - Added `n`/`N` → `nzzzv`/`Nzzzv`.
  - Only `Ø` stays `silent` (it runs a `/` search that would otherwise echo).
  - The old `opts` table had `silent = true` on `<leader>y/p`, `<`, `>` and `<Esc>`. Those don't echo with `<cmd>`/register keys, so I dropped it.
- 3.3 `config/options.lua` uses `vim.opt` only, grouped. The values are unchanged; §4 changes `updatetime` and adds new options.
- 3.4 Deleted `lua/bru/vscode_keymaps.lua`. Its `ø` → `$` and `<C-l>` → `V$` were **not** migrated: the file was never loaded and the spec didn't list them. If the user wants them, they belong in `shared.lua`. Also removed lualine `copilot`, the wrong "yellow" comments in `theme.lua`, and the cmp file header comment.
- 3.5 Updated AGENTS.md: the conventions, `n`/`N` in the shared table, and removed the `bru` and copilot entries.

Headless check (`g:vscode=1`, stubbed `package.preload.vscode`): `MISSING=` and `NODESC=` were empty; the `h3` and `bb` callbacks fired `vscode-harpoon.gotoEditor3,workbench.action.toggleSidebarVisibility`; `n=nzzzv`; `LAZY=false`. Standalone: clipboard `unnamedplus`, and `<Esc>` → `<Cmd>nohlsearch<CR><Esc>`.

`BUILD_EXIT:0` `FORMAT_EXIT:0` `VALIDATE_EXIT:0` `GATES_EXIT:0`

Question to user: do the mappings behave correctly inside VSCode, and do you want `ø` → `$` migrated?

## Next

- On "yes": tick 3.1–3.5, write the section-3-done note, commit `feat(cleanup-config): readability cleanup (§3)`, then §4 starting with 4.1 (options).
- If the user wants `ø`/`<C-l>`, add them to `shared.lua` with a `desc` and update the AGENTS.md table in §3 before committing.
