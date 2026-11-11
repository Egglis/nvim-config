## ADDED Requirements

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
