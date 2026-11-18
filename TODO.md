# TODO

Ideas not yet started. Each one becomes an OpenSpec change (`/opsx-explore` or `/opsx-propose`) when picked up.

- [ ] **Yank history** — a yank ring to get back earlier yanks/deletes and cycle through them after a paste
  (e.g. `gbprod/yanky.nvim`, with a snacks picker for the history).
- [ ] **Undo tree** — browse the undo history as a tree. Neovim 0.12 may ship one (`:packadd nvim.undotree`,
  then `:Undotree`); check that first, else `mbbill/undotree`. `undofile` is already on.
- [ ] **Snacks modules** — turn on the ones not used yet (no new plugin): `bigfile` (no tree-sitter/LSP on huge
  files), `quickfile` (show `nvim file` sooner), `statuscolumn` (signs, folds, diagnostics in one column),
  `scope` (`ii`/`ai` text objects, `[i`/`]i` jumps), `rename` (LSP-aware file renames from the explorer),
  `input` (nicer `vim.ui.input`, e.g. LSP rename), `zen`, `scratch` (per-project scratch buffers), `toggle`
  (which-key-aware toggles for diagnostics, inlay hints, spell, wrap). Check each against existing keys and the
  VSCode side.
- [ ] **Improved startup** — `vim.loader.enable()` (Lua module bytecode cache), then measure with
  `:Lazy profile` / `nvim --startuptime` and move plugins that load at start but needn't to lazy events.
- [ ] **Diagnostics list** — a better diagnostics/quickfix list than the `<leader>fd` picker: grouped by file,
  stays open while fixing (e.g. `folke/trouble.nvim` or `stevearc/quicker.nvim`).
- [ ] **Better Markdown** — render-markdown for ordinary `.md` files (today only the OpenCode panel), the
  `marksman` LSP, and maybe a browser preview (`markdown-preview.nvim`).
