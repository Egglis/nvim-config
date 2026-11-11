## ADDED Requirements

### Requirement: Search the current file
In standalone Neovim, `<C-f>` SHALL open a fuzzy picker over the lines of the current buffer, in normal and visual mode. Moving through the list SHALL show the selected line in the editor window; confirming SHALL jump to the match in that window. In visual mode the selected text SHALL be the starting query. The picker SHALL follow the closing, resume and on-demand loading rules of the other pickers.

#### Scenario: Find a line
- **WHEN** the user presses `<C-f>` in normal mode in a file and types `repo_accent`
- **THEN** the list shows the file's lines matching `repo_accent`, the editor window scrolls to the selected one, and `<CR>` puts the cursor on that match and closes the picker

#### Scenario: Selection as query
- **WHEN** the user selects `attach_lualine` in visual mode and presses `<C-f>`
- **THEN** the picker opens with `attach_lualine` as its query and lists the lines containing it

#### Scenario: Close without jumping
- **WHEN** the picker is open and the user presses `Ctrl+c`
- **THEN** the picker closes and the cursor is where it was before `<C-f>`

#### Scenario: Not in VSCode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** this config defines no `<C-f>` mapping
