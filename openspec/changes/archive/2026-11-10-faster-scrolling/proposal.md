# Proposal

## Why

Holding `j`/`k` feels laggy in bigger files, mostly C#. In a real console, scrolling a 6,000-line C# file
cost about 1.2 ms of redraw per step with this config. Turning off the regex syntax highlighting cut that
to 0.4 ms, and so did turning off `cursorline`, which makes the regex highlighter redo two lines on every
move. In a Lua file, where Neovim already uses tree-sitter, tree-sitter highlighting cost about the same
as no highlighting at all (0.42 vs 0.39 ms; regex Lua highlighting was 0.72 ms). C# gets the old regex
highlighting because Neovim 0.11 ships no C# parser and the config has no way to install one. The
maintained way to install parsers (nvim-treesitter's `main` branch) needs Neovim 0.12. The installed
Neovim is 0.11.0, and the current stable release is 0.12.6.

## What Changes

- **Upgrade Neovim from 0.11.0 to 0.12.6** (winget). The config is checked against 0.12's breaking changes
  (none of the removed APIs are used here) and the pwsh shell settings are rechecked, since 0.12 changed
  the `shelltemp` default.
- **Tree-sitter highlighting** for C#, XML, JSON, PowerShell and Python in standalone Neovim, through
  `nvim-treesitter` (`main` branch). The parsers are installed automatically. Lua, Markdown, Vimscript and
  help files keep the parsers Neovim ships with. MSBuild `.props`/`.targets` files are detected as XML.
  A file whose parser isn't installed yet keeps regex highlighting, with no error.
- **Cheaper cursor moves**: bracket matching (`matchparen`) gives up after 20 ms instead of the defaults
  (300 ms in normal mode, 60 ms in insert mode), and regex highlighting stops at column 300
  (`synmaxcol`, default 3000) for the languages that still use it.
- **Before/after numbers**: the agent measures with a throwaway script outside the repo (nothing is
  added to `gates.ps1`) and records the results in the devlog, to check the result and to decide about
  `relativenumber` and `cursorline` with numbers.
- `relativenumber` and `cursorline` **stay on**. If the measurement still shows a clear cost from either
  after tree-sitter, the user decides whether to change them; this change doesn't decide it.
- New tools: **tree-sitter CLI** (0.26.1+, `scoop install tree-sitter`) and a **C compiler**, which the
  parser install needs. The machine already has Visual Studio Build Tools 2019 with the C++ tools. Both
  go in `docs/dependencies.md` and the `deps` gate. Neovim's row becomes `0.12+`.

Out of scope: a benchmark in the repo or in `gates.ps1`, Roslyn semantic tokens and a "big file" mode
(nothing measured points at them yet), tree-sitter folding, indentation and text objects, other
languages, the Windows keyboard repeat rate and Windows Terminal settings, and VSCode mode, which loads
no plugins and is unchanged.

## Capabilities

### New Capabilities
- `syntax-highlighting`: how standalone Neovim colours source files: tree-sitter for the listed
  languages, parsers installed automatically, MSBuild files as XML, a quiet fallback when a parser is
  missing, and no effect on startup or VSCode mode.

### Modified Capabilities
- `editor-options`: new requirement for cursor-move cost (bracket matching time limit, `synmaxcol`). The
  display requirement (`relativenumber`, `cursorline`) is unchanged.
- `config-health`: new requirement that the config targets Neovim 0.12+.

## Impact

- Neovim itself: 0.11.0 → 0.12.6. This affects vscode-neovim too, which uses the same `nvim`.
- New plugin `nvim-treesitter/nvim-treesitter` (`main`) in a new `lua/plugins/treesitter.lua`;
  `lazy-lock.json` changes. Plugins may need `:Lazy update` if one breaks on 0.12.
- Changed: `lua/config/options.lua` (matchparen, `synmaxcol`, filetype for `.props`/`.targets`).
- Dependencies: tree-sitter CLI and a C compiler in `docs/dependencies.md` and `gates.ps1 deps`.
- Docs: `AGENTS.md` (plugins table, options, a short "Syntax highlighting" note), `readme.md`.
