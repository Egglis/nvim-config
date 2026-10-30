# Stopped: §2 waiting for human LSP verification

<!-- Section: 2 · Tasks: 2.1–2.5 · Base: 7e94e20 -->

The §2 work is implemented and uncommitted; tasks are unticked until the user verifies.

- 2.1 `lua/plugins/lsp.lua` now uses `mason-org/mason.nvim` (`opts = {}`, set up once) and `mason-org/mason-lspconfig.nvim` v2 (`ensure_installed` + `automatic_enable`). It calls `vim.lsp.config("*", { capabilities })` and `vim.lsp.config(name, server)` for each entry in `lsp/servers.lua`. Lockfile: mason.nvim `2a6940a`, mason-lspconfig `cd6c64d` (stable-26), lazydev added, neodev removed. All other plugins are untouched.
- 2.2 `folke/lazydev.nvim` (`ft = "lua"`, luv library for `vim.uv`) replaces neodev. It is the first cmp source (`group_index = 0`).
- 2.3 `lua/lsp/keymaps.lua` exposes `M.setup()`, which registers an `LspAttach` autocmd (augroup `config-lsp-attach`). Telescope is required inside the callback. The code-action `only` filter is dropped. `:Format` passes `bufnr`.
- 2.4 `vim.diagnostic.config({ virtual_text = true, severity_sort = true, float = { border = "rounded" } })` in the lspconfig `config` function.
- 2.5 The AGENTS.md plugins and LSP sections are updated.

Gotchas:
- `Lazy! install` re-clones renamed-org plugins at the old locked commit. A separate `Lazy! update mason.nvim mason-lspconfig.nvim` run is needed to move them.
- Headless checks on `init.lua` hit `E325 ATTENTION` because the user has it open. Use `nvim -n`.
- Headless `print` doesn't reach the pipe. Use `io.stdout:write`.

Headless verification script (`%TEMP%\opencode\lspcheck.lua`, run with `nvim --headless -n -i NONE "+luafile …" +qa`):
- `ATTACHED=true`
- `LSPMAPS=11`
- `FORMAT=true`
- `UNDEF_VIM=0`
- `VTEXT=true`
- `ENEW_LSPMAPS=0`
- `ERR=` (empty)

`BUILD_EXIT:0` `FORMAT_EXIT:0` `VALIDATE_EXIT:0` `GATES_EXIT:0`

Question to user: in real Neovim, do hover, rename, `:Format`, inline diagnostics and code actions behave correctly?

## Next

- On "yes": tick 2.1–2.5, write the section-2-done note, commit `feat(cleanup-config): modernise LSP for Neovim 0.11 (§2)`, hand off, then §3 starting with 3.1 (`vscode.lua` `action()` helper).
- On a problem: fix within §2 and re-verify. Don't tick until confirmed.
