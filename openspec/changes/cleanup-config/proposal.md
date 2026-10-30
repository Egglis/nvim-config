# Proposal

## Why

The config works day to day, but it is fragile and harder to read than it needs to be. A fresh install crashes because `lsp_config.lua` requires plugins before lazy.nvim has installed them. Plugin loading depends on `type(...) == "function"` guards that hide mistakes. Several mappings and settings are duplicated or dead. The LSP stack uses deprecated plugins (`neodev`) and the pre-0.11 setup style, even though Neovim 0.11 is installed.

## What Changes

- **Robustness fixes**
  - Defer plugin `require`s in the LSP code so the config starts on a machine with no plugins installed.
  - Make `init.lua` call keymap modules directly and load lazy.nvim on its own line; remove the startup `print`s.
  - Rename `lua/lazy/init_lazy.lua` to `lua/config/lazy.lua` so it no longer shadows the `lazy` module namespace.
  - Fix the cmp mapping table that sets `<Tab>` twice, and keep a single `completeopt`.
  - Set up Mason only once.
  - Remove the duplicate `<leader>fa` mapping.
- **Modernise for Neovim 0.11**
  - Replace `neodev.nvim` with `lazydev.nvim`.
  - Switch `williamboman/*` to `mason-org/*`.
  - Configure servers with `vim.lsp.config` / `vim.lsp.enable`, and set LSP keymaps from an `LspAttach` autocmd.
  - Add an explicit `vim.diagnostic.config`.
  - Replace `vim.loop` with `vim.uv`.
  - Move telescope off the old `0.1.x` tag.
  - Drop the code-action kind filter.
- **Readability**
  - Leave `vscode.lua` as written (user decision during §3).
  - Use `<cmd>…<CR>` mappings, each with a `desc`.
  - Use one option API (`vim.opt`) in grouped sections.
  - Split `lsp_config.lua` into `lua/lsp/servers.lua` and `lua/lsp/keymaps.lua`.
  - Remove dead code: `lua/bru/vscode_keymaps.lua` (after moving its `n`/`N` re-centering into `shared.lua`), the `copilot` lualine component, unused `opts` locals, the duplicate mappings in `regular.lua`, and stale comments.
  - Move `clipboard = unnamedplus` into the options module (standalone Neovim only).
- **Sensible defaults**
  - Options: `undofile`, `signcolumn=yes`, `expandtab`, `splitright`/`splitbelow`, `cursorline`, and `updatetime=250`.
  - Telescope: `live_grep`, `buffers` and `help_tags` pickers.
  - cmp: a buffer source and snippet expansion through `vim.snippet`.
- Existing user-chosen overrides of built-in keys stay as they are: `B`, `E`, `<C-a>`, and `J`/`K` in VSCode.
- Out of scope: treesitter, conform.nvim, new language servers, and theme changes.

## Capabilities

### New Capabilities
- `keymaps`: Which mappings exist in each environment (shared, VSCode-only, standalone-only), and the rule that the shared and VSCode paths load no plugins.
- `lsp`: Language-server behaviour in standalone Neovim: server install and attach, buffer-local LSP keymaps, `:Format`, and diagnostics display.
- `editor-options`: Editor option defaults (indentation, search, line numbers, undo persistence, sign column, splits, clipboard).

### Modified Capabilities
- `config-health`: Adds two requirements. The config must start cleanly when no plugins are installed yet, and startup must print no informational messages.

## Impact

- Code: `init.lua`, everything under `lua/`, and `lazy-lock.json` (new and renamed plugins).
- Plugins: adds `folke/lazydev.nvim` and `hrsh7th/cmp-buffer`; removes `folke/neodev.nvim`; `mason.nvim` and `mason-lspconfig.nvim` move to the `mason-org` org. No new external tools, so `docs/dependencies.md` is unchanged.
- Docs: `AGENTS.md` (directory structure, keymaps, plugins, Known Issues table).
- Behaviour: there is no keymap removal visible to the user. New options (`expandtab`, `undofile`) change editing behaviour slightly.
