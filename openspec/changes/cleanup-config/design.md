# Design

## Context

Neovim 0.11.0 on Windows. One repo serves two runtimes: standalone Neovim (full plugin stack) and VSCode via vscode-neovim, where no plugins load. The `build` gate starts Neovim headless with `init.lua` and fails if `vim.v.errmsg` is non-empty. It does not cover VSCode mode or a fresh plugin directory. Plugin versions are pinned in `lazy-lock.json`.

## Goals / Non-Goals

**Goals:**
- A fresh clone starts without Lua errors.
- Every file has one clear job and no dead code or duplicates.
- Use Neovim 0.11 native LSP APIs and maintained plugins.
- Keep all mappings the user has today, and add descriptions.

**Non-Goals:**
- Treesitter, conform.nvim, new language servers, theme or statusline redesign.
- Changing the user's deliberate overrides of built-in keys (`B`, `E`, `<C-a>`, and `J`/`K` in VSCode).
- Extending `gates.ps1` beyond the targets it has (verification scripts may be run ad hoc).

## Decisions

1. **Module layout.**
   - `lua/config/{options,lazy}.lua`
   - `lua/keymaps/{shared,vscode,regular}.lua` (unchanged names)
   - `lua/lsp/{servers,keymaps}.lua`
   - `lua/plugins/*.lua`
   - Delete `lua/options/`, `lua/lazy/` and `lua/bru/`.

   Why: `lua/lazy/` shares its name with the plugin's `lazy` module, and a `config/` namespace groups core setup. *Alternative:* keep the paths and only fix bugs. Rejected because the `lazy` name collision is a latent bug.
2. **Keymap modules keep the "return a function" convention**, documented in AGENTS.md. `init.lua` calls them directly with no `type()` guards, so a broken module fails loudly.
3. **Options module, with clipboard set only in standalone mode.** `config/options.lua` sets shared options. Settings that only matter in standalone Neovim (`clipboard`, `undofile`, `signcolumn`, `cursorline`, `splitright`/`splitbelow`) go in a `if not vim.g.vscode then` block. This keeps the existing `config-health` clipboard scenario true.
4. **LSP setup with `vim.lsp.config('*', { capabilities })` plus one `vim.lsp.config(name, cfg)` per server.**
   - `mason-org/mason-lspconfig.nvim` v2 `ensure_installed` installs the servers, and its `automatic_enable` enables them.
   - Keymaps and `:Format` are set in an `LspAttach` autocmd in `lsp/keymaps.lua`.
   - Telescope and cmp are `require`d lazily, inside callbacks.

   Why: this is the native 0.11 path; mason-lspconfig v2 removed `handlers`; and lazy `require`s fix the fresh-install crash. *Alternative:* keep the `on_attach` and `handlers` style and pin the old mason-lspconfig. Rejected because it is a dead end.
5. **`servers.lua` is data only.** It maps each server name to `{ settings = …, filetypes = … }`, and the plugin spec reads it inside `config`. It requires no plugins.
6. **`lazydev.nvim` replaces `neodev.nvim`** (`ft = "lua"`) and is registered as a cmp source.
7. **cmp cleanup.**
   - One mapping table, with `<Tab>`/`<S-Tab>` selecting items when the menu is visible and falling back otherwise.
   - `snippet.expand = function(a) vim.snippet.expand(a.body) end`, with `<Tab>`/`<S-Tab>` jumping between snippet placeholders when `vim.snippet.active()`.
   - Sources: `nvim_lsp`, `lazydev`, `path`, `buffer`.
   - The global `completeopt` is removed from options. cmp owns it.
8. **`lua/keymaps/vscode.lua` is left as written** (user decision during §3). The only change to it is §1's removal of the identical duplicate `<leader>fa` line. No helper refactor and no `desc`s.
9. **Shared keymaps:**
   - Use `<cmd>w<CR>` and `<cmd>nohlsearch<CR>`.
   - Add `n`/`N` → `nzzzv`/`Nzzzv`, moved from the legacy file.
   - Remove the duplicate `<leader>y` and `<C-s>` from `regular.lua`.
   - `regular.lua` holds only mappings that are truly standalone-only (it may become nearly empty; keep it for structure).
10. **Telescope** follows the `master` branch, pinned by the lockfile. Add mappings `<leader>fa` live_grep (matching VSCode's `<leader>fa` meaning: global search), `<leader>fb` buffers and `<leader>fh` help_tags. `live_grep` needs `ripgrep`. See Risks.
11. **Diagnostics:** `vim.diagnostic.config({ virtual_text = true, severity_sort = true, float = { border = "rounded" } })`, set in the lspconfig `config` function.
12. **Fresh-install verification** is done ad hoc: run headless with a temporary `XDG_DATA_HOME` and `+Lazy! sync`. Record the command in the devlog. It is not added as a gate.

## Risks / Trade-offs

- **`live_grep` needs `ripgrep`**, which is not in `docs/dependencies.md`. Adding it is a stop-and-ask during §4. The fallback is to omit `<leader>fa` in standalone mode.
- **`expandtab` changes how new indentation is written.** Existing tab-indented files are not rewritten.
- **Plugin org rename and API changes** (mason-lspconfig v2) may change `lazy-lock.json` substantially. Commit the lock update in the same section as the spec changes.
- **Human verification is needed** for VSCode-mode mappings and LSP behaviour in a live buffer. The gates cannot see these.
