# Tasks

## 1. Robustness fixes and module layout

- [ ] 1.1 Move `lua/options/options.lua` to `lua/config/options.lua` and `lua/lazy/init_lazy.lua` to `lua/config/lazy.lua`, using `vim.uv` instead of `vim.loop`; update `init.lua`. Verify: `lua/options/` and `lua/lazy/` no longer exist, and `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`.
- [ ] 1.2 Rewrite `init.lua` to call the keymap modules directly (no `type()` guards), load `config.lazy` only when not in VSCode mode, and drop the `print`s. Verify: `nvim --headless "+lua print(#vim.split(vim.fn.execute('messages'), '\n'))" +qa` shows no config-originated message, and `nvim --headless --cmd "let g:vscode=1" "+lua io.write(tostring(package.loaded.lazy ~= nil))" +qa` prints `false`.
- [ ] 1.3 Split `lua/lsp_config.lua` into `lua/lsp/servers.lua` (data only, no `require`s) and `lua/lsp/keymaps.lua`; make `lua/plugins/lsp.lua` load them inside `config`; set up Mason only once. Verify the fresh-install scenario: headless start with an empty temp `XDG_DATA_HOME`/`LOCALAPPDATA` plus `+Lazy! sync` raises no config error, and a second start is clean. Record the exact command in the devlog.
- [ ] 1.4 Fix `lua/plugins/cmp.lua`: one `<Tab>` entry, and `completeopt` owned by cmp only (removed from options). Verify: `pwsh ./gates.ps1 gates` is all green.
- [ ] 1.5 Remove the duplicate `<leader>fa` in `lua/keymaps/vscode.lua` and the duplicate `<leader>y`/`<C-s>` and unused `opts` in `lua/keymaps/regular.lua`; move `clipboard = unnamedplus` into the standalone block of `config/options.lua`. Verify: `nvim --headless "+lua io.write(vim.o.clipboard)" +qa` prints `unnamedplus`.
- [ ] 1.6 Update `AGENTS.md` (directory structure, boot logic, Known Issues entries now fixed). Verify by reading the diff against the new tree.

## 2. Modernise LSP for Neovim 0.11

- [ ] 2.1 Switch to `mason-org/mason.nvim` and `mason-org/mason-lspconfig.nvim` v2. Configure servers through `vim.lsp.config('*', …)` and a per-server `vim.lsp.config(name, …)`, enabled via `ensure_installed`/`automatic_enable`; update `lazy-lock.json`. Verify: opening `init.lua` headless and waiting shows `lua_ls` in `vim.lsp.get_clients({ bufnr = 0 })`.
- [ ] 2.2 Replace `neodev.nvim` with `folke/lazydev.nvim` (`ft = "lua"`) and add it as a cmp source. Verify: in `init.lua`, `lua_ls` reports no `undefined global 'vim'` diagnostic.
- [ ] 2.3 Move LSP keymaps and `:Format` into an `LspAttach` autocmd in `lua/lsp/keymaps.lua`, requiring telescope inside the callbacks, and drop the code-action `only` filter. Verify: after attach, `nvim_buf_get_keymap(0, 'n')` contains all 11 LSP mappings with descriptions, and a non-LSP buffer (`:enew`) has none.
- [ ] 2.4 Add `vim.diagnostic.config({ virtual_text = true, severity_sort = true, float = { border = "rounded" } })`. Verify: `vim.diagnostic.config().virtual_text` is truthy headless.
- [ ] 2.5 Update the plugins and LSP sections of `AGENTS.md`. Then stop for human verification: give the user a recipe to check hover, rename, `:Format` and inline diagnostics in a live Lua buffer.

## 3. Readability

- [ ] 3.1 Rewrite `lua/keymaps/vscode.lua` with a local `action(cmd)` helper, a `desc` on every mapping, and a `for` loop for Harpoon slots 1–9, keeping the same keys and commands. Verify: a headless run with `g:vscode=1` and a stubbed `vscode` module lists every key from the keymaps spec exactly once, each with a `desc`.
- [ ] 3.2 Clean up `lua/keymaps/shared.lua`: use `<cmd>w<CR>` and `<cmd>nohlsearch<CR>`, add `n`/`N` re-centering, add a `desc` on every mapping, and fix stale comments. Verify: headless `maparg('n', 'n')` is `nzzzv`, and every config mapping has a non-empty `desc`.
- [ ] 3.3 Rewrite `lua/config/options.lua` using `vim.opt` only, grouped by section. Verify: the headless option values match the editor-options spec, apart from options §4 adds.
- [ ] 3.4 Delete `lua/bru/vscode_keymaps.lua`; remove the `copilot` lualine component; add `desc` to the telescope mapping. Verify: `rg -n "bru|copilot" lua init.lua` returns nothing, and `pwsh ./gates.ps1 gates` is all green.
- [ ] 3.5 Update the keymaps tables and Known Issues in `AGENTS.md`. Then stop for human verification: give the user a recipe to try the shared and VSCode mappings inside VSCode.

## 4. Sensible defaults

- [ ] 4.1 Add options: `expandtab`, `updatetime=250`, and in standalone mode only `undofile`, `signcolumn=yes`, `cursorline`, `splitright`, `splitbelow`. Verify: headless option values match every scenario in the editor-options spec.
- [ ] 4.2 Ask the user to agree to adding `ripgrep` to `docs/dependencies.md` and the `deps` target. Once agreed, add the row and its check. Verify: `pwsh ./gates.ps1 deps` → `DEPS_EXIT:0`.
- [ ] 4.3 Add telescope mappings `<leader>fa` live_grep, `<leader>fb` buffers and `<leader>fh` help_tags, with descriptions, and move telescope off the `0.1.x` tag. Verify: headless `maparg` shows all four `<leader>f*` mappings.
- [ ] 4.4 Add `hrsh7th/cmp-buffer` and `vim.snippet`-based snippet expansion with `<Tab>`/`<S-Tab>` jumping between placeholders. Verify: `pwsh ./gates.ps1 gates` is all green, then stop for human verification of snippet expansion in a live buffer.
- [ ] 4.5 Update `AGENTS.md` for the new options, pickers and plugins. Verify by reading the diff.

## Workflow follow-up

- Whole-change self-review and an optional independent review, per AGENTS.md.
- Archive with `/opsx-archive` once reviews are done.
