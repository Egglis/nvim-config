# Tasks

## 1. Neovim 0.12

- [x] 1.1 Record the **baseline** on Neovim 0.11.0 with the throwaway measurement script in `$env:TEMP\opencode\` (design decision 7; nothing committed): a generated C# and Lua file, each with defaults, highlighting off, `norelativenumber`, `nocursorline` and `NoMatchParen`, run twice. Verify: both runs' output, verbatim, in a devlog note
- [x] 1.2 `deps` gate: the `nvim` check fails below 0.12 (design decision 2); `docs/dependencies.md` Neovim row → `0.12+`, install hint `winget upgrade Neovim.Neovim`. Verify on 0.11.0: `pwsh ./gates.ps1 deps` prints the "nvim 0.12+" message and not `DEPS_EXIT:0`
- [x] 1.3 **Stop for the user** (design decision 1): close every Neovim (including VSCode windows), run `winget upgrade Neovim.Neovim`, reopen. Verify: `nvim --version` → `NVIM v0.12.6` (or a later 0.12.x), and `pwsh ./gates.ps1 deps` no longer reports nvim
- [x] 1.4 Check the config on 0.12: `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`; headless, a `.lua` buffer gets `lua_ls` attached and the LSP keymaps are set; snacks, lualine and opencode setups raise no error; `:messages` after startup holds nothing from the config. Update only a plugin that fails (`:Lazy update <name>`), and commit `lazy-lock.json` with this section. Verify: the listed checks pass, quoted in the devlog note
- [x] 1.5 Re-check the pwsh shell on 0.12 (design: Risks): `:!$PSVersionTable.PSVersion.Major` prints 7 with no profile output; `vim.fn.system("exit 3")` gives `v:shell_error` 3; `:%!sort` on a 3-line buffer sorts it. If one fails, adjust `lua/config/options.lua` following 0.12's `:h shell-pwsh` and record why in a devlog note. Verify: all three pass headless
- [x] 1.6 Docs: `AGENTS.md` mentions of "Neovim 0.11" (LSP section) → 0.12 where it's about the installed version. Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 2. Tree-sitter highlighting

- [ ] 2.1 Dependencies (design decision 3): `scoop install tree-sitter`; check a parser builds from a plain pwsh (e.g. `tree-sitter build` in a clone of `tree-sitter-json`, or the first plugin install in 2.2). If MSVC isn't found, try the zig fallback; if neither works, stop and ask. Add rows to `docs/dependencies.md` (tree-sitter CLI 0.26.1+; C compiler: VS Build Tools VC tools) and `Check` lines to `gates.ps1 deps` (`tree-sitter --version` ≥ 0.26.1; `vswhere … -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64` returns a path). Verify: in a new pwsh, `pwsh ./gates.ps1 deps` → `DEPS_EXIT:0`
- [ ] 2.2 Add `lua/plugins/treesitter.lua` (design decision 4): `main` branch, `lazy = false`, `build = ":TSUpdate"`, install of only the missing parsers in `vim.schedule` when `tree-sitter` is executable, and a `FileType` autocmd for `cs`, `xml`, `json`, `ps1`, `python` calling `pcall(vim.treesitter.start, buf)`. Verify: after one start and the installs finishing, headless: opening a `.cs`, `.csproj`, `appsettings.json`, `.ps1` and `.py` file each gives `vim.treesitter.highlighter.active[buf] ~= nil` and an empty `vim.bo.syntax`; a `.lua` file still has tree-sitter; `pwsh ./gates.ps1 build` → `BUILD_EXIT:0`; a second start prints no messages (`:messages` empty of config output)
- [ ] 2.3 Fallback and fresh install: headless with a temporary data directory (`XDG_DATA_HOME`/`LOCALAPPDATA` override) and `tree-sitter` hidden from `PATH`, opening a `.py` file raises no error and leaves `vim.bo.syntax == "python"`; then with `tree-sitter` on `PATH` the parsers install and a second start is clean (config-health fresh-install requirement). Verify: both runs' outputs quoted in the devlog note
- [ ] 2.4 Docs: `AGENTS.md` plugins table row for nvim-treesitter (`treesitter.lua`, `main`, languages, not lazy), directory tree entry, and a "Syntax highlighting" note (languages, parsers install on start, fallback). Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 3. Cursor-move settings

- [ ] 3.1 In `lua/config/options.lua`'s standalone block (design decisions 5 and 6): `vim.g.matchparen_timeout = 20`, `vim.g.matchparen_insert_timeout = 20`, `opt.synmaxcol = 300`, and `vim.filetype.add({ extension = { props = "xml", targets = "xml" } })`. Verify: headless standalone shows the three values; `vim.filetype.match({ filename = "Common.props" })` and `"x.targets"` → `xml`; with `vim.g.vscode = true` (`nvim --headless --cmd "let g:vscode=1" -u init.lua`) the values are Neovim's defaults (300, 60, 3000); bracket matching still highlights the pair on a `(` in a C# buffer (a `MatchParen` match exists in `getmatches()` after `CursorMoved`)
- [ ] 3.2 Docs: `AGENTS.md` Options table (`synmaxcol`, matchparen limits, `.props`/`.targets` → xml) and `readme.md` (performance TODO with the result). Verify: `pwsh ./gates.ps1 gates` → `GATES_EXIT:0`

## 4. Measure and check

- [ ] 4.1 Repeat the measurement from 1.1 twice on the finished change, and put the outputs and a before/after table in the devlog note. Verify: the C# default line is clearly lower than the baseline and shows tree-sitter
- [ ] 4.2 **Stop for the user** with the numbers: does `relativenumber` or `cursorline` still cost enough to change? Record the answer in a devlog note; a change to either becomes a new section or a TODO, not part of this one unless agreed. Verify: the answer is in the devlog
- [ ] 4.3 **Human check**, following a recipe the agent provides: hold `j`/`k` in a big real C# file and in a Lua file (smooth?); C#, `.csproj`, `appsettings.json`, a `.ps1` and a `.py` file look correctly coloured; bracket highlight still shows on `(`/`{`; `:!` and the terminal still work; VSCode with vscode-neovim starts and the shared keys (`<leader>y`, `<C-d>`, `Ø`) work. Verify: the user's answers recorded in the devlog

## Workflow follow-up

- Whole-change review, change-done note, offer an independent review, then offer `/opsx-archive`.
