# Yet another neovim config repo
Also a powershell $profile file!

## TODO

- [x] Custom color theming based on which repo/workspace I am within should maybe use the .vscode/settings that already exists
- [x] Git tree/sidebar for simple git actions, probably some plugin
  - Done as lazygit in a float (`<leader>gg`) plus git pickers under `<leader>g`. Gutter signs (gitsigns) still open
- [ ] Simple file treeview with symbols and git tracking
- [ ] Other UI improvements for a clean and simpler interface
  - [x] Start screen on a plain `nvim`: repo name, quick keys, recent files and projects
  - [ ] Less clutter: trim lualine (drop `encoding`/`fileformat`), `cmdheight=0`, no `showmode` (lualine shows it), hide the `~` end-of-buffer markers
  - [ ] Consistent floating windows: rounded borders on hover, signature help, the cmp menu/docs, `:Lazy` and `:Mason`
  - [ ] Key guidance: which-key popup with named `<leader>` groups (`f` find, `t` terminal, `o` opencode, `b` buffers, `h` harpoon …)
  - [ ] Nicer notifications/messages: `snacks.notifier` for `vim.notify` (maybe `noice` for the cmdline, but it's heavier)
  - [ ] Editor visuals: indent guides (`snacks.indent`) and highlight other uses of the word under the cursor (`snacks.words`). Git signs in the gutter belong to the git TODO
  - [ ] Completion polish: kind icons, borders and ghost text in nvim-cmp
- [x] Terminal plugin for running scripts and projects directly within the same session
- [x] Add a open recent projects directly in neovim that lists all previous neovim repo/sessions similar to vscode
- [ ] Better search in the current file than the standard `/`
- [x] .NET user secrets: jump from a `.csproj` straight to its `secrets.json` (by `UserSecretsId`), like the VSCode extension (`<leader>ns`)
- [ ] Continue where I left off: `nvim --continue` (or similar) reopens the last session as it was at `:qa!` — auto `:mksession` on exit + a pwsh wrapper/alias and a start-screen key. Global vs per-folder session undecided; maybe tmux-style (psmux/WezTerm/Windows Terminal) persistence on Windows instead
- [ ] Show open buffers: buffer list in the repo-accent top bar (lualine `buffers` component), plus Harpoon 2 with the same `<leader>h…` keys as VSCode
