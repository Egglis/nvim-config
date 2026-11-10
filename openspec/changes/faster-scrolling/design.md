# Design

## Context

See proposal.md (Why). Facts found while researching, on this machine (Windows, pwsh 7):

- Neovim 0.11.0 is installed from winget (`Neovim.Neovim`, under `C:\Program Files\Neovim`); winget
  offers 0.12.6, the current stable release. Neovim ships parsers only for C, Lua, Markdown(+inline),
  query, Vimscript and vimdoc. `.cs` buffers use the regex `syntax/cs.vim`.
- nvim-treesitter is split. `master` is frozen and supports only Neovim 0.10/0.11. `main` is a rewrite
  that needs Neovim 0.12+, `tar` and `curl` (both in Windows' System32), tree-sitter CLI 0.26.1+ (not
  from npm) and a C compiler. It doesn't support lazy-loading. It installs parsers with
  `require("nvim-treesitter").install(langs)` (async, a no-op for installed ones) into
  `stdpath("data")/site`, and doesn't start highlighting itself: the config calls
  `vim.treesitter.start()` from a `FileType` autocmd. Its parser names: `c_sharp` (filetype `cs`), `xml`
  (requires `dtd`), `json`, `powershell` (filetype `ps1`), `python`.
- Compiler: Visual Studio Build Tools 2019 with the VC tools is installed (found with `vswhere`), but `cl`
  is not on `PATH`. `zig` 0.14.1 is on `PATH`. scoop has `tree-sitter` 0.27.2.
- Filetypes on 0.11: `.csproj`, `Directory.Build.props/targets` → `xml`; a plain `Common.props` or
  `x.targets` → none.
- Neovim 0.12 breaking changes checked against the config: none of the removed APIs
  (`vim.diagnostic.disable`, `sign_define` signs, `vim.diff`, `semantic_tokens.start/stop`) is used.
  `shelltemp` now defaults to off, and `:h shell-powershell` in 0.12 recommends `noshelltemp` with a
  simpler `shellpipe`. The current pwsh settings come from the 0.11 help.
- `matchparen` (Neovim runtime): on every `CursorMoved` it runs `searchpairpos()` with a 300 ms limit
  (60 ms in insert mode). In regex-highlighted buffers the skip test calls `synstack()` per candidate
  bracket; in tree-sitter buffers it asks tree-sitter for captures instead.
- Spike measurement (TUI in a `conhost` window, 300 × `j` + `redraw`, ms per step). The C# file was a
  generated 6,000-line file and the Lua file a generated 7,500-line file. Roslyn had probably not
  attached yet, 3 s after opening.

  | Setting | C# (regex) | Lua (tree-sitter) |
  |---|---|---|
  | config defaults | 1.17 | 0.42 |
  | `syntax off` | 0.43 | 0.39 (no highlighting) |
  | `nocursorline` | 0.63 | |
  | `norelativenumber` | 1.04 | |
  | `norelativenumber nocursorline` | 0.51 | |
  | `NoMatchParen` | 1.03 | |
  | `synmaxcol=200` | 1.25 (short lines: no effect) | |
  | regex Lua instead of tree-sitter | | 0.72 |

  A plain headless run can't measure this (no UI, so no redraw). Attaching a UI to a child Neovim over
  RPC from another Neovim also failed: the parent rejects `redraw` notifications and the child exits.

## Goals / Non-Goals

**Goals:** the three spec deltas; tree-sitter highlighting for C#, XML, JSON, PowerShell and Python on
the maintained plugin branch; numbers before and after; nothing new at startup; nothing in VSCode mode.

**Non-Goals:** tree-sitter folds, indentation, incremental selection or text objects; more languages;
Roslyn semantic tokens or a big-file mode; changing `relativenumber`/`cursorline` without the user's
decision; the Windows key repeat rate or terminal settings; updating plugins that don't need it.

## Decisions

1. **Upgrade Neovim to 0.12.6 with winget, as a user step.** `winget upgrade Neovim.Neovim` replaces
   `nvim.exe` under Program Files (UAC prompt), which fails or is unsafe while any Neovim runs. The user
   may run this session inside Neovim, so the agent stops and hands it over: close every Neovim
   (including VSCode windows using vscode-neovim), run the upgrade, reopen. The agent then checks
   `nvim --version` and the gates.
   *Alternative:* stay on 0.11 with nvim-treesitter `master` and zig. Rejected by the user: frozen
   branch, redone at the next upgrade.
2. **The `deps` gate checks the Neovim version.** The `nvim` check parses `nvim --version`'s first line
   (`NVIM v0.12.6`) and throws when it's below 0.12, so `Check` reports
   `MISSING nvim 0.12+ — winget upgrade Neovim.Neovim`. `docs/dependencies.md`: Neovim `0.12+`.
3. **New dependencies: tree-sitter CLI and a C compiler.**
   - tree-sitter CLI: `scoop install tree-sitter` (0.27.2; scoop is already used for `fd`). Check:
     `tree-sitter --version`, and the version is at least 0.26.1.
   - C compiler: the installed VS Build Tools (VC tools) are the expected one; tree-sitter CLI's build
     finds MSVC through the Visual Studio installer without `cl` on `PATH`. The `deps` check uses
     `vswhere -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64`. Install hint: `winget install
     Microsoft.VisualStudio.2022.BuildTools` with the C++ workload.
   *Alternative:* zig as the compiler (`CC="zig cc"`). Kept only as the fallback if the MSVC route fails
   in §2 (see Risks); that would be a devlog decision and a different deps row.
4. **One new spec file, `lua/plugins/treesitter.lua`.**
   `{ "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate", config = … }`.
   `config`:
   - The language list lives once in the file: `c_sharp`, `xml`, `json`, `powershell`, `python`, plus the
     filetypes to start on: `cs`, `xml`, `json`, `ps1`, `python`.
   - Install only what's missing, after startup: in `vim.schedule`, if `tree-sitter` is executable, call
     `install()` with the languages not in `require("nvim-treesitter").get_installed()`. When nothing is
     missing, nothing runs, so startup stays silent. Without the CLI nothing runs either, and the `deps`
     gate is what reports it. `:TSUpdate` (lazy's `build`) updates parsers when the plugin updates.
   - A `FileType` autocmd for those filetypes calls `pcall(vim.treesitter.start, buf)`. If the parser is
     missing, `start` fails inside the `pcall` and the buffer keeps regex highlighting (spec: quiet
     fallback). `vim.treesitter.start` turns regex syntax off for that buffer itself.
   - Lua, Markdown, Vimscript and help keep the tree-sitter highlighting Neovim's own ftplugins start.
   *Alternatives:* a `FileType` autocmd for every filetype with a parser (more languages than asked);
   `master` with `highlight = { enable = true }` (frozen, see 1).
5. **`.props`/`.targets` as XML:** `vim.filetype.add({ extension = { props = "xml", targets = "xml" } })`
   in the standalone block of `lua/config/options.lua`. Filetype detection must not depend on a plugin
   loading. `.csproj` and `Directory.Build.*` are already `xml`.
6. **Cursor-move settings in `options.lua`'s standalone block:** `vim.g.matchparen_timeout = 20`,
   `vim.g.matchparen_insert_timeout = 20`, `opt.synmaxcol = 300`. They must be set before the matchparen
   plugin runs, which `options.lua` is (it loads first, and runtime plugins load after `init.lua`).
   20 ms still finds a pair in normal code; only a search that would take longer gives up, and then no
   pair is highlighted. 300 columns covers normal code; only longer lines lose colour after column 300,
   and only in regex-highlighted filetypes.
   *Alternative:* `NoMatchParen` (no bracket highlight at all); the spike showed matchparen is a small
   part of the cost.
7. **Measuring: a throwaway script, not part of the repo.** The user doesn't want a benchmark in
   `gates.ps1`. The agent keeps the spike's script in `$env:TEMP\opencode\` (generated C#/Lua files,
   `conhost.exe nvim -u init.lua <file> -c "luafile …"`, `lines=40 columns=160`, 5 s settle, then
   300 × `normal! j` + `doautocmd CursorMoved` + `redraw` per setting) and pastes the outputs into the
   devlog: a baseline before the upgrade (1.1), and the result after §3. Nothing from it is committed.
   *Alternatives:* a `bench` gate target (rejected by the user: annoying); a UI attached over RPC (fails,
   see Context); manual `:syntime` (regex only, no totals).
8. **`relativenumber`/`cursorline`: measure, then ask.** The spike shows `cursorline` mattering with
   regex highlighting. After tree-sitter the measurement is repeated, and the user gets the numbers and
   chooses: keep both, or change them in a follow-up.
9. **Order: baseline, then the upgrade, then tree-sitter, then the settings.** Each later section can be
   compared with the baseline, and the upgrade is checked on its own before a new plugin depends on it.

## Risks / Trade-offs

- [Plugins pinned in `lazy-lock.json` may break on 0.12] → After the upgrade, the `build` gate and a
  headless check of the LSP/cmp/snacks/opencode setups. Update only the plugin that fails (`:Lazy update
  <name>`), and commit the lockfile change in that section.
- [tree-sitter CLI might not find MSVC from a plain pwsh] → §2 starts with a manual
  `tree-sitter build` check; if it fails, fall back to `CC`/zig or a VS developer shell. That is
  recorded as a devlog decision and changes the deps row; if neither works, stop and ask.
- [The 0.12 shell defaults change `:!` and filter behaviour] → Re-run the `editor-options` shell
  scenarios (`:!$PSVersionTable.PSVersion.Major`, `system("exit 3")`, profile in the terminal) on 0.12,
  plus a filter (`:%!sort`). Change the shell settings only if one fails, and follow the 0.12 help.
- [vscode-neovim also runs the upgraded `nvim`] → VSCode mode loads no plugins; a manual check that
  VSCode still starts its Neovim and the shared keys work.
- [Parser installs run in the background on the first start after this change; a file opened before they
  finish keeps regex highlighting] → Accepted (spec: quiet fallback); reopening the file (`:e`) picks up
  tree-sitter.
- [The measurement opens a console window for a few seconds per run and measures conhost, not Windows
  Terminal] → Only run by the agent at two points; the numbers are for before/after comparison, not
  absolute truth.
- [`synmaxcol=300` stops colour on long lines in regex filetypes] → Only for filetypes without
  tree-sitter; long lines are rare in code.
