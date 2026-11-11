## ADDED Requirements

### Requirement: Search the current file
In standalone Neovim, `<C-f>` SHALL open a fuzzy picker over the lines of the current buffer, in normal and visual mode, as a centred float laid out like the other pickers. Moving through the list SHALL show the selected line in the picker's preview; confirming SHALL jump to the match in the original window. In visual mode the selected text SHALL be the starting query. The picker SHALL follow the closing and on-demand loading rules of the other pickers.

#### Scenario: Find a line
- **WHEN** the user presses `<C-f>` in normal mode in a file and types `repo_accent`
- **THEN** a centred float lists the file's lines matching `repo_accent`, its preview shows the selected line in the file, and `<CR>` puts the cursor on that match in the original window and closes the picker

#### Scenario: Selection as query
- **WHEN** the user selects `attach_lualine` in visual mode and presses `<C-f>`
- **THEN** the picker opens with `attach_lualine` as its query and lists the lines containing it

#### Scenario: Close without jumping
- **WHEN** the picker is open and the user presses `Ctrl+c`
- **THEN** the picker closes and the cursor is where it was before `<C-f>`

#### Scenario: Not in VSCode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** this config defines no `<C-f>` mapping

### Requirement: Resume the current-file search
In standalone Neovim, `<leader><C-f>` SHALL reopen the last current-file search with its query, in the current buffer. When there has been no current-file search yet, it SHALL open a new one. `<leader>fR` SHALL keep resuming the last picker of any kind.

#### Scenario: Resume after other pickers
- **WHEN** the user searched `repo_accent` with `<C-f>`, closed it, then used `<leader>ff` and closed that, and presses `<leader><C-f>`
- **THEN** the current-file search reopens with `repo_accent` as its query

#### Scenario: Nothing to resume
- **WHEN** no current-file search has been opened since Neovim started and the user presses `<leader><C-f>`
- **THEN** a current-file search opens with an empty query

#### Scenario: Not in VSCode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** this config defines no `<leader><C-f>` mapping
