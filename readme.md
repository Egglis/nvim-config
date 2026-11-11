# Yet another neovim config repo
Also a powershell $profile file!

## TODO

- [x] Custom color theming based on which repo/workspace I am within should maybe use the .vscode/settings that already exists
- [x] Git tree/sidebar for simple git actions, probably some plugin
- [x] Simple file treeview with symbols and git tracking: snacks explorer on `<leader>fe`, a centred float with a preview (like the git pickers), or a right sidebar on `<leader>e`, git and diagnostic marks and add/rename/move/copy/delete (to the Recycle Bin). Plain snacks glyphs, no icon plugin
- [ ] Other UI improvements for a clean and simpler interface
  - [x] Start screen on a plain `nvim`: repo name, quick keys, recent files and projects
  - [ ] Less clutter: trim lualine (drop `encoding`/`fileformat`), `cmdheight=0`, no `showmode` (lualine shows it), hide the `~` end-of-buffer markers
  - [ ] Consistent floating windows: rounded borders on hover, signature help, the cmp menu/docs, `:Lazy` and `:Mason`
  - [ ] Key guidance: which-key popup with named `<leader>` groups (`f` find, `t` terminal, `o` opencode, `b` buffers, `h` harpoon …)
  - [ ] Nicer notifications/messages: `snacks.notifier` for `vim.notify` (maybe `noice` for the cmdline, but it's heavier)
  - [ ] Editor visuals: indent guides (`snacks.indent`) and highlight other uses of the word under the cursor (`snacks.words`). Git signs in the gutter belong to the git TODO
  - [ ] Completion polish: kind icons, borders and ghost text in nvim-cmp
  - [ ] Harmonize lazygit with the rest: it looks very different from the pickers/floats (border, colors, icons, layout), make it match the tokyonight/snacks look and the repo accent
- [x] Terminal plugin for running scripts and projects directly within the same session
- [x] Add a open recent projects directly in neovim that lists all previous neovim repo/sessions similar to vscode
- [ ] Better search in the current file than the standard `/`
- [ ] Easier macros: simpler record/replay keys than `q{reg}`/`@{reg}`, a visible "recording @q" indicator (lualine, needed if `cmdheight=0`), and a way to view/edit/pick saved macros
- [x] .NET user secrets: jump from a `.csproj` straight to its `secrets.json` (by `UserSecretsId`), like the VSCode extension (`<leader>ns`)
- [x] Continue where I left off: per-project session saved on exit (also `:qa!`), restored with `s` on the start screen, `<leader>qs`, `:SessionRestore` or `nvc` in pwsh
- [ ] Show open buffers: buffer list in the repo-accent top bar (lualine `buffers` component), plus Harpoon 2 with the same `<leader>h…` keys as VSCode
- [x] Faster scrolling in big C# files: Neovim 0.12, tree-sitter highlighting for C#/XML/JSON/PowerShell/Python instead of regex syntax, and cheaper cursor moves (bracket matching capped at 20 ms, regex highlighting stops at column 300). Holding `j` in a 6,000-line C# file: ~1.5–2.1 → 0.34 ms per step



## TODO: Move everything to WSL 2.0 instead, make it cross compatible! 
