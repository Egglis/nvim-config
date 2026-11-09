# git Specification

## Purpose
Gives standalone Neovim simple git actions (stage, commit, push and browse history) through a lazygit
panel and a few git lookup keys, without slowing startup or affecting VSCode mode.

## Requirements

### Requirement: Open the lazygit panel
In standalone Neovim, `<leader>gg` in normal mode SHALL open lazygit in a floating window over the editor, for the repository of Neovim's current working directory, with the cursor in it. Quitting lazygit SHALL close the float and return to the window the user came from.

#### Scenario: Open and quit
- **WHEN** Neovim's cwd is inside a git repo and the user presses `<leader>gg`
- **THEN** lazygit opens in a float showing that repo's changed files, and pressing `q` in lazygit closes the float and puts the cursor back in the previous window

#### Scenario: Commit from the panel
- **WHEN** the user stages a file with `<Space>` in lazygit, presses `c`, types a message and confirms
- **THEN** the commit is created in the repo, as with `git commit`

### Requirement: Lazygit matches the editor colors
The lazygit panel SHALL use colors taken from the current Neovim colorscheme, so it does not look like a separate program.

#### Scenario: Themed panel
- **WHEN** the user opens the lazygit panel with the tokyonight colorscheme active
- **THEN** lazygit's borders, selected line and text use colors from that colorscheme

### Requirement: Edit a file from lazygit in this Neovim
Pressing `e` on a file in the lazygit panel SHALL open that file in the same Neovim instance that opened lazygit, in an editor window, not in a second Neovim inside the float.

#### Scenario: Edit from the files list
- **WHEN** the lazygit panel is open and the user presses `e` on a changed file
- **THEN** the file opens as a buffer in this Neovim and the cursor is in an editor window, not in a nested Neovim

### Requirement: Git lookup keys
In standalone Neovim, these normal-mode keys SHALL open git views of Neovim's cwd repo: `<leader>gs` changed files (stage and restore like `<leader>fg`), `<leader>gl` commit log, `<leader>gf` commits that changed the current file, `<leader>gb` branches (confirm checks one out), `<leader>gB` blame for the current line, `<leader>go` the current file on the remote's website.

#### Scenario: File history
- **WHEN** the user is in a tracked file and presses `<leader>gf`
- **THEN** a picker lists the commits that changed that file, with a preview of each commit's diff

#### Scenario: Switch branch
- **WHEN** the user presses `<leader>gb` and confirms another local branch
- **THEN** that branch is checked out

#### Scenario: Open on the remote
- **WHEN** the user presses `<leader>go` in a tracked file of a repo whose remote is on GitHub
- **THEN** the browser opens that file's page on GitHub

#### Scenario: LSP keys are kept
- **WHEN** an LSP server is attached and the user presses `<leader>gd`, `<leader>gr` or `<leader>gi`
- **THEN** the LSP definition, references or implementation picker opens, as before

### Requirement: Git keys outside a repo fail cleanly
When Neovim's cwd is not inside a git repo, the git keys SHALL NOT raise a Lua error; they SHALL either show a message or leave the choice to lazygit.

#### Scenario: Not a repo
- **WHEN** Neovim's cwd is a folder with no git repo and the user presses `<leader>gl`
- **THEN** no Lua error is shown

### Requirement: Git tools load on demand
Neither lazygit nor the git views SHALL start during Neovim startup; lazygit SHALL start only when `<leader>gg` is pressed. The git keys SHALL load the plugin they need the first time they are used.

#### Scenario: Startup with a file
- **WHEN** standalone Neovim starts with a file argument and no git key has been pressed
- **THEN** no lazygit process is running

### Requirement: Git keys are absent in VSCode mode
When `vim.g.vscode` is set, the config SHALL NOT define the `<leader>g…` git keys from this capability, and VSCode's own `<leader>gr` mapping SHALL keep working.

#### Scenario: VSCode mode
- **WHEN** Neovim runs inside VSCode via vscode-neovim and the user presses `<leader>gr`
- **THEN** VSCode's Go to References runs, and no lazygit or git picker opens
