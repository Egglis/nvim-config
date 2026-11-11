# picker Specification

## Purpose
Gives standalone Neovim fuzzy pickers for finding files, text, buffers, help, recent files, projects, diagnostics and git changes, plus a VSCode-style command palette, without slowing startup or affecting VSCode mode.

## Requirements

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
`<leader>fp` SHALL open one picker listing every normal-mode key mapping that has a description, searchable by that description, together with every `:` command. Confirming a mapping SHALL run it; confirming a command that needs no argument SHALL run it, and confirming any other command SHALL type it on the command line for the user to finish.

#### Scenario: Run a mapping by name
- **WHEN** the user presses `<leader>fp`, types `terminal toggle`, and confirms the matching entry
- **THEN** the terminal panel toggles, as if `<leader>tt` had been pressed

#### Scenario: Run a command
- **WHEN** the user presses `<leader>fp`, types `Lazy`, and confirms the `:Lazy` entry
- **THEN** the lazy.nvim window opens

### Requirement: Keymap and command pickers
`<leader>fk` SHALL list the key mappings and `<leader>fc` the `:` commands, each runnable on confirm (commands as in the command palette), as separate pickers.

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
The picker plugin SHALL NOT be loaded during Neovim startup, unless the start screen is shown; it SHALL load the first time a picker key, an LSP list key or a selection list is used. When Neovim is started with a file or directory argument, the picker plugin SHALL stay unloaded until then.

#### Scenario: Plain startup
- **WHEN** standalone Neovim starts with a file argument and no picker has been used
- **THEN** the picker plugin is not loaded

#### Scenario: Start screen startup
- **WHEN** standalone Neovim starts with no arguments, so the start screen is shown
- **THEN** the picker plugin may be loaded, and every picker key works as usual

### Requirement: Pickers are absent in VSCode mode
When `vim.g.vscode` is set, the config SHALL NOT load the picker plugin, and the `<leader>f…` keys SHALL keep their VSCode mappings.

#### Scenario: VSCode mode
- **WHEN** Neovim runs inside VSCode via vscode-neovim and the user presses `<leader>ff`
- **THEN** VSCode's own search in the current file opens, and no Neovim picker plugin is loaded

### Requirement: Search the current file
In standalone Neovim, `<C-f>` SHALL open a fuzzy picker over the lines of the current buffer, as a centred float laid out like the other pickers. Moving through the list SHALL show the selected line in the picker's preview; confirming SHALL jump to the match in the original window. The picker SHALL follow the closing and on-demand loading rules of the other pickers.

#### Scenario: Find a line
- **WHEN** the user presses `<C-f>` in normal mode in a file and types `repo_accent`
- **THEN** a centred float lists the file's lines matching `repo_accent`, its preview shows the selected line in the file, and `<CR>` puts the cursor on that match in the original window and closes the picker

#### Scenario: Close without jumping
- **WHEN** the picker is open and the user presses `Ctrl+c`
- **THEN** the picker closes and the cursor is where it was before `<C-f>`

#### Scenario: Not in VSCode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** this config defines no `<C-f>` mapping

### Requirement: The current-file search remembers its query
In normal mode, `<C-f>` SHALL reopen the last current-file search with its query, applied to the current buffer, even after other pickers were used. When there has been no current-file search yet, it SHALL open with an empty query.

#### Scenario: Reopen after other pickers
- **WHEN** the user searched `repo_accent` with `<C-f>`, closed it, then used `<leader>ff` and closed that, and presses `<C-f>`
- **THEN** the current-file search opens with `repo_accent` as its query

#### Scenario: First search
- **WHEN** no current-file search has been opened since Neovim started and the user presses `<C-f>`
- **THEN** the current-file search opens with an empty query

### Requirement: The selection starts a new current-file search
In visual mode, `<C-f>` SHALL open the current-file search with the selected text as its query, replacing the remembered one.

#### Scenario: Selection as query
- **WHEN** the user selects `attach_lualine` in visual mode and presses `<C-f>`
- **THEN** the picker opens with `attach_lualine` as its query and lists the lines containing it

### Requirement: Clearing the current-file query
While the current-file search is open, `<C-f>` SHALL clear its query, leave the user typing in the input, and list all of the buffer's lines again.

#### Scenario: Start over
- **WHEN** `<C-f>` reopened the search with `repo_accent` and the user presses `<C-f>` again
- **THEN** the query is empty, the cursor is in the input in insert mode, and the list shows every line of the buffer
