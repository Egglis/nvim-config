# Stopped: §4 waiting for snippet verification

<!-- Section: 4 · Tasks: 4.1–4.6 · Base: 1b25ad4 -->

The §4 work is implemented and uncommitted; tasks are unticked.

User rulings this session:
- "go ahead": add ripgrep (4.2 agreed).
- **"do not change the shared"**: `lua/keymaps/shared.lua` was restored to the original (`git diff a7e4463 -- lua/keymaps/shared.lua` is empty), and task 4.6 was added to record it. The keymaps spec drops `n`/`N` and the re-centre scenario, and the desc requirement excludes shared and vscode. Design Decision 9, the proposal and the AGENTS.md conventions/table were updated to match.

Landed:
- 4.1 Options: `expandtab`, `updatetime=250`, plus the standalone-only `undofile`, `signcolumn=yes`, `cursorline`, `splitright` and `splitbelow`. Headless check gave `et=true ut=250 undo=true scl=yes cul=true spr=true sb=true` and the rest per spec. In VSCode mode: `et=true undo=false clip= ut=250`.
- 4.2 Added a ripgrep row to `docs/dependencies.md` and `Check 'MISSING rg …'` in the `gates.ps1` deps target. `DEPS_EXIT:0`.
- 4.3 Telescope: removed `tag`, updated to `40aedd8`, and added `<leader>fa`/`fb`/`fh` with descs. The deprecation warnings from §2 are gone, and headless `<leader>gd` still lands in `servers.lua`.
- 4.4 Added `cmp-buffer` (`b74fab3`) and `snippet.expand` via `vim.snippet`, with `<Tab>`/`<S-Tab>` jumping between placeholders when no menu is visible.
- 4.5 Updated AGENTS.md: telescope, cmp, plugins and options tables. Known Issues is now empty.

`DEPS_EXIT:0` `BUILD_EXIT:0` `FORMAT_EXIT:0` `VALIDATE_EXIT:0` `GATES_EXIT:0`

Question to user: does LSP snippet expansion and placeholder jumping work (recipe uses a scratch buffer, no tracked files)?

## Next

- On "yes": tick 4.1–4.6, write the section-4-done note, commit `feat(cleanup-config): sensible defaults (§4)`, hand off, then the whole-change review (`git diff a7e4463..HEAD`).
- On a problem: fix within §4 and re-verify.
