# start-screen Specification

## Purpose

Gives standalone Neovim a start screen when it is opened without a file: the current repo's name, quick keys for the usual first actions, and recent files and projects, without slowing startup when a file is opened or affecting VSCode mode.

## Requirements

### Requirement: Start screen appears on a plain start
Standalone Neovim started with no file or directory arguments SHALL show the start screen in place of the empty buffer. When started with any file or directory argument, it SHALL NOT show the start screen.

#### Scenario: Plain nvim
- **WHEN** the user runs `nvim` with no arguments
- **THEN** the start screen is shown

#### Scenario: Opening a file
- **WHEN** the user runs `nvim init.lua`
- **THEN** `init.lua` is opened and no start screen is shown

#### Scenario: Opening a directory
- **WHEN** the user runs `nvim .`
- **THEN** no start screen is shown, and the directory opens as it did before this change

### Requirement: Header shows the repo
The start screen's header SHALL show the name of the repo Neovim's cwd is in, in that repo's accent color, using the same repo and color as the repo accent. Outside a repo it SHALL show "Neovim" in the normal header color.

#### Scenario: Inside a repo
- **WHEN** Neovim starts with no arguments inside a repo whose accent is `#ff9e64`
- **THEN** the header shows the repo's folder name in `#ff9e64`

#### Scenario: Outside a repo
- **WHEN** Neovim starts with no arguments in the home folder
- **THEN** the header shows "Neovim" in the normal header color

### Requirement: Menu keys
The start screen SHALL list these entries, each run by its single key while the screen is focused: `f` find files, `g` live grep, `r` recent files, `p` recent projects, `n` new empty buffer, `c` config, `L` the plugin manager window, `q` quit Neovim. `f`, `g`, `r` and `p` SHALL behave as `<leader>ff`, `<leader>fa`, `<leader>fr` and `<leader>fP`.

#### Scenario: Find a file
- **WHEN** the start screen is shown and the user presses `f`
- **THEN** the file picker opens in Neovim's cwd, the same as `<leader>ff`

#### Scenario: Quit
- **WHEN** the start screen is shown and the user presses `q`
- **THEN** Neovim exits

### Requirement: Config entry switches to the config
The `c` entry SHALL change Neovim's cwd (globally) to the Neovim config folder and open the file picker there.

#### Scenario: Open the config
- **WHEN** the start screen is shown and the user presses `c`
- **THEN** Neovim's cwd becomes the config folder, the repo accent updates to it, and the file picker opens there

### Requirement: Recent files list
The start screen SHALL list up to 5 recently opened files. Inside a repo it SHALL list only files in that repo; outside a repo it SHALL list recent files from anywhere. Confirming one SHALL open it.

#### Scenario: Recent files in a repo
- **WHEN** Neovim starts with no arguments inside a repo, and recent files exist both in and outside it
- **THEN** only files inside the repo are listed, newest first, at most 5

#### Scenario: Recent files outside a repo
- **WHEN** Neovim starts with no arguments in the home folder
- **THEN** the most recent files from any folder are listed, at most 5

### Requirement: Projects list
The start screen SHALL list up to 10 recently used project folders. Confirming one SHALL change Neovim's cwd globally to that folder and open the file picker there, as `<leader>fP` does.

#### Scenario: Open a project
- **WHEN** the start screen is shown and the user confirms a listed project
- **THEN** Neovim's cwd becomes that folder, the repo accent updates to it, and the file picker opens in it

### Requirement: List entry keys
Each recent file and project SHALL have its own key: `1` to `9` and `0` first, then letters. No entry SHALL use a menu key or `h`, `j`, `k`, `l`, and the cursor SHALL move through the entries with `j`/`k`, opening the entry under it with `<CR>`.

#### Scenario: Open by number
- **WHEN** the start screen lists recent files and the user presses `1`
- **THEN** the first recent file opens

#### Scenario: Move and confirm
- **WHEN** the start screen is shown and the user presses `j` a few times, then `<CR>`
- **THEN** the cursor moved down the entries, and the entry under it runs

### Requirement: Start screen is absent in VSCode mode
When `vim.g.vscode` is set, the config SHALL NOT show the start screen or load its plugin.

#### Scenario: VSCode mode
- **WHEN** VSCode starts with vscode-neovim and this config
- **THEN** no start screen is shown and no Neovim plugin is loaded
