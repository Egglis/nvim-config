# Yet another neovim config repo
Also a powershell $profile file!

Runs on Windows and in WSL (Fedora): see [docs/wsl.md](docs/wsl.md) for the WSL setup.

## TODO
- [x] Custom color theming based on which repo/workspace I am within should maybe use the .vscode/settings that already exists
- [x] Git tree/sidebar for simple git actions, probably some plugin
- [x] Simple file treeview with symbols and git tracking: snacks explorer on `<leader>fe`, a centred float with a preview (like the git pickers), or a right sidebar on `<leader>e`, git and diagnostic marks and add/rename/move/copy/delete (to the Recycle Bin). Plain snacks glyphs, no icon plugin
- [x] Other UI improvements for a clean and simpler interface
  - [x] Start screen on a plain `nvim`: repo name, quick keys, recent files and projects
  - [x] Less clutter: trim lualine (drop `encoding`/`fileformat`), `cmdheight=0`, no `showmode` (lualine shows it), hide the `~` end-of-buffer markers
  - [x] Key guidance: which-key popup with named `<leader>` groups (`f` find, `t` terminal, `o` opencode, `b` buffers, `g` git …), toggled with `<leader>uw`
  - [x] Nicer notifications/messages: `snacks.notifier` for `vim.notify` (maybe `noice` for the cmdline, but it's heavier)
  - [x] Editor visuals: indent guides (`snacks.indent`) and highlight other uses of the word under the cursor (`snacks.words`). Git signs in the gutter belong to the git TODO
  - [x] Completion polish: kind icons, borders and ghost text in nvim-cmp
- [x] Terminal plugin for running scripts and projects directly within the same session
- [x] Add a open recent projects directly in neovim that lists all previous neovim repo/sessions similar to vscode
- [x] Better search in the current file than the standard `/`: matches stay highlighted until `<Esc>`, `n`/`N` centred, `[3/7]` count in the statusline, and `<C-f>` fuzzy-searches the file's lines in a centred picker with a preview; like VSCode it reopens with the last query, `<C-f>` again clears it, and in visual mode the selection is the query
- [x] Easier macros: default keys kept (`qq … q`, `Q`/`3Q`, `@@`, select lines + `Q`), a red `REC @q` block in the statusline while recording, and `<leader>fm` to list macros readably, run one (`<CR>`) or edit it in a float (`<C-e>`, `:w` saves)
- [x] .NET user secrets: jump from a `.csproj` straight to its `secrets.json` (by `UserSecretsId`), like the VSCode extension (`<leader>ns`)
- [x] Continue where I left off: per-project session saved on exit (also `:qa!`), restored with `s` on the start screen, `<leader>qs`, `:SessionRestore` or `nvc` in pwsh/zsh
- [x] Remember less-used shortcuts: which-key popup while typing (`<leader>uw`), precognition motion hints (`<leader>up`) and the hardtime habit trainer (`<leader>uh`); each toggles with a notification and is remembered across restarts. `<leader>fp`/`<leader>fc` are the searchable cheatsheet
- [x] Easier buffer navigation without tabs: file marks per project with grapple.nvim on the same keys as VSCode's harpoon (`<leader>ha` mark/unmark, `<leader>hh` search the marks, `<leader>he` edit the list, `<leader>h1`–`h9` jump). `<leader>fb` lists buffers and closes them with `<C-x>`/`dd`
- [x] Faster scrolling in big C# files: Neovim 0.12, tree-sitter highlighting for C#/XML/JSON/PowerShell/Python instead of regex syntax, and cheaper cursor moves (bracket matching capped at 20 ms, regex highlighting stops at column 300). Holding `j` in a 6,000-line C# file: ~1.5–2.1 → 0.34 ms per step
- [x] Move everything to WSL 2.0 instead, make it cross compatible! Same `master` on Windows and in WSL Fedora: per-platform shell, win32yank clipboard and Windows browser in WSL, trash on delete, `gates.sh`, a zsh profile with the pwsh aliases and prompt, and the setup in [docs/wsl.md](docs/wsl.md)


