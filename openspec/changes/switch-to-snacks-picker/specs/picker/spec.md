# Spec Delta

## Purpose

Gives standalone Neovim fuzzy pickers for finding files, text, buffers, help, recent files, projects, diagnostics and git changes, plus a VSCode-style command palette, without slowing startup or affecting VSCode mode.

## ADDED Requirements

### Requirement: Find pickers
In standalone Neovim, the config SHALL provide normal-mode find keys that open a fuzzy picker: `<leader>ff` files in the cwd, `<leader>fa` live grep of the cwd, `<leader>fb` open buffers, `<leader>fh` help tags, `<leader>fr` recent files, `<leader>fd` diagnostics, `<leader>fg` git changed files, and `<leader>fR` reopens the last picker.

#### Scenario: Find files
- **WHEN** the user presses `<leader>ff` in normal mode
- **THEN** a picker lists the files under Neovim's cwd, and confirming one opens it

#### Scenario: Live grep
- **WHEN** the user presses `<leader>fa` and types a search term
- **THEN** the picker lists matching lines across the cwd, and confirming one jumps to that line

#### Scenario: Resume
- **WHEN** the user closes a picker after typing a query, then presses `<leader>fR`
- **THEN** the same picker reopens with the same query

### Requirement: Grep the word under the cursor
`<leader>fw` SHALL search the cwd for the word under the cursor in normal mode, and for the selected text in visual mode.

#### Scenario: Word under cursor
- **WHEN** the cursor is on the word `repo_accent` and the user presses `<leader>fw`
- **THEN** a picker lists every line in the cwd containing `repo_accent`

### Requirement: Command palette
`<leader>fp` SHALL open one picker listing every normal-mode key mapping that has a description, searchable by that description, together with every `:` command. Confirming a mapping SHALL run it; confirming a command SHALL run it.

#### Scenario: Run a mapping by name
- **WHEN** the user presses `<leader>fp`, types `terminal toggle`, and confirms the matching entry
- **THEN** the terminal panel toggles, as if `<leader>tt` had been pressed

#### Scenario: Run a command
- **WHEN** the user presses `<leader>fp`, types `Lazy`, and confirms the `:Lazy` entry
- **THEN** the lazy.nvim window opens

### Requirement: Keymap and command pickers
`<leader>fk` SHALL list the key mappings and `<leader>fc` the `:` commands, each runnable on confirm, as separate pickers.

#### Scenario: Find a keymap
- **WHEN** the user presses `<leader>fk` and types `find files`
- **THEN** the `<leader>ff` mapping is listed with its description

### Requirement: Recent projects
`<leader>fP` SHALL list recently used project folders. Confirming one SHALL change Neovim's cwd to that folder and open the file picker there.

#### Scenario: Switch project
- **WHEN** the user presses `<leader>fP` and confirms another repo
- **THEN** Neovim's cwd becomes that repo, the repo accent updates to it, and the file picker opens in it

### Requirement: Closing a picker
In any picker opened by the config, `Ctrl+c` SHALL close it from insert and normal mode, and `q` SHALL close it from normal mode. `<Esc>` SHALL NOT close a picker: in insert mode it switches the picker to normal mode.

#### Scenario: Ctrl+c while typing
- **WHEN** a picker is open and the user is typing in its input
- **THEN** `Ctrl+c` closes the picker and returns to the previous window

#### Scenario: Esc does not close
- **WHEN** a picker is open and the user presses `<Esc>` while typing, then `<Esc>` again
- **THEN** the picker is still open, in normal mode, and `j`/`k` move through the list

### Requirement: Selection lists use the picker
Lists that Neovim or a plugin shows through `vim.ui.select` (for example code actions) SHALL open in the same picker, with the same closing keys, even before any find key has been used.

#### Scenario: Code action before any picker
- **WHEN** standalone Neovim has started, no picker has been used, and the user presses `<leader>ca` where the server offers actions
- **THEN** the actions are listed in the picker, and `Ctrl+c` closes it without applying one

### Requirement: Pickers load on demand
The picker plugin SHALL NOT be loaded during Neovim startup; it SHALL load the first time a picker key, an LSP list key or a selection list is used.

#### Scenario: Plain startup
- **WHEN** standalone Neovim starts and no picker has been used
- **THEN** the picker plugin is not loaded

### Requirement: Pickers are absent in VSCode mode
When `vim.g.vscode` is set, the config SHALL NOT load the picker plugin, and the `<leader>f…` keys SHALL keep their VSCode mappings.

#### Scenario: VSCode mode
- **WHEN** Neovim runs inside VSCode via vscode-neovim and the user presses `<leader>ff`
- **THEN** VSCode's own search in the current file opens, and no Neovim picker plugin is loaded
