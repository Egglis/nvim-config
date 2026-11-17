# Spec Delta

## Purpose

Gives standalone Neovim a short, hand-picked list of files per project, each with a fixed number, so the
user can jump between the files they are working on without tabs or a buffer bar, using the same keys as
their VSCode harpoon setup.

## ADDED Requirements

### Requirement: Mark the current file
In standalone Neovim, `<leader>ha` SHALL add the current file to the project's mark list if it is not in it, and remove it if it is. Each press SHALL show a notification saying which happened, including the mark's number when added. A new mark SHALL go to the end of the list.

#### Scenario: Add a mark
- **WHEN** the project has two marks and the user presses `<leader>ha` in an unmarked file
- **THEN** the file becomes mark 3 and a notification says it was marked as 3

#### Scenario: Remove a mark
- **WHEN** the user presses `<leader>ha` in a file that is already marked
- **THEN** the file is no longer in the list and a notification says it was unmarked

#### Scenario: Buffer without a file
- **WHEN** the user presses `<leader>ha` in a buffer that has no file (e.g. a new empty buffer or a terminal)
- **THEN** nothing is marked and no error is raised

### Requirement: Jump to a mark by number
In standalone Neovim, `<leader>h1` to `<leader>h9` SHALL open the file at that position in the project's mark list, at the cursor position it last had. A number with no mark SHALL show a short message and change nothing.

#### Scenario: Jump to mark 2
- **WHEN** the project has three marks and the user presses `<leader>h2`
- **THEN** the second marked file is shown in the current window

#### Scenario: No mark at that number
- **WHEN** the project has two marks and the user presses `<leader>h5`
- **THEN** the current buffer stays as it is and a message says there is no mark 5

### Requirement: Search the marks
In standalone Neovim, `<leader>hh` SHALL open a picker listing the project's marked files in list order, each with its number, filterable by typing, with a preview. Confirming an entry SHALL open that file. The picker SHALL follow the closing and on-demand loading rules of the other pickers.

#### Scenario: Pick a mark
- **WHEN** the project has three marks and the user presses `<leader>hh`, types part of the second file's name and presses `<CR>`
- **THEN** the picker closes and the second marked file is shown

#### Scenario: No marks
- **WHEN** the project has no marks and the user presses `<leader>hh`
- **THEN** the picker opens with no entries (or reports that there are none) and no error is raised

### Requirement: Edit the mark list
In standalone Neovim, `<leader>he` SHALL open a window showing the project's mark list, where the user can jump to a mark (`<CR>`, or its number `1`–`9`), remove marks by deleting lines, and reorder marks by moving lines. Changes SHALL apply when the window closes.

#### Scenario: Reorder
- **WHEN** the user opens the window with `<leader>he`, moves the third line to the top and closes it
- **THEN** that file is now mark 1 and `<leader>h1` opens it

#### Scenario: Remove
- **WHEN** the user deletes a line in the window and closes it
- **THEN** that file is no longer marked

### Requirement: Marks per project and saved
The mark list SHALL belong to the project: the git repository of Neovim's current directory, else the current directory. Each project SHALL keep its own list, and lists SHALL survive restarting Neovim.

#### Scenario: Survives a restart
- **WHEN** the user marks two files, quits Neovim and starts it again in the same repository
- **THEN** `<leader>h1` and `<leader>h2` open the same two files

#### Scenario: Another project
- **WHEN** the user changes the current directory to a different repository
- **THEN** the mark keys use that repository's own list, and switching back restores the first list

### Requirement: Marks do not change buffers or the screen
Marking, unmarking and editing the list SHALL NOT open, close or hide any buffer by themselves, and this capability SHALL add nothing to the top bar or the statusline.

#### Scenario: Unmark keeps the buffer
- **WHEN** the user unmarks the current file with `<leader>ha`
- **THEN** the buffer stays open and listed in `<leader>fb`

### Requirement: Marks are absent in VSCode mode
When Neovim runs with `vim.g.vscode` set, this capability SHALL define no mappings and load nothing; the `<leader>h…` keys there keep their VSCode harpoon commands.

#### Scenario: VSCode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** `<leader>ha` runs the VSCode harpoon command and no mark plugin is loaded
