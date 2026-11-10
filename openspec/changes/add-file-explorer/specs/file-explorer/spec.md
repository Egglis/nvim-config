# Spec Delta

## Purpose

Defines the file tree float in standalone Neovim: how it opens and closes, what it shows, the simple
file and folder operations it offers, and how it fits the picker and terminal keys.

## ADDED Requirements

### Requirement: Toggle the file tree
In standalone Neovim, `<leader>fe` SHALL open a file tree in a centred float laid out like the other pickers (the tree with its filter line on one side, a preview on the other), showing the tree of Neovim's current working directory with the cursor in it. Pressing `<leader>fe` while the tree is open SHALL close it.

#### Scenario: Open
- **WHEN** no file tree is open and the user presses `<leader>fe` in normal mode
- **THEN** a centred float opens showing the files and folders of the cwd, and the cursor is in the tree

#### Scenario: Close with the same key
- **WHEN** the file tree is open and the user presses `<leader>fe`
- **THEN** the tree closes

#### Scenario: Follows the current file
- **WHEN** a file inside the cwd is open and the user opens the tree
- **THEN** the tree expands to that file and puts the cursor on it

### Requirement: Opening a file closes the tree
Confirming a file in the tree SHALL open it in the main editor window and SHALL close the tree, like the other pickers. Confirming a folder SHALL expand or collapse it and keep the tree open.

#### Scenario: Open a file
- **WHEN** the cursor is on a file in the tree and the user presses `<CR>`
- **THEN** the file opens in the editor window and the tree closes

#### Scenario: Expand a folder
- **WHEN** the cursor is on a collapsed folder and the user presses `<CR>`
- **THEN** the folder expands to show its contents and the tree stays open

### Requirement: Create files and folders
From the tree, the user SHALL be able to create a file or a folder in the folder under the cursor by typing its name; a name ending in `/` SHALL create a folder.

#### Scenario: New file
- **WHEN** the cursor is in a folder in the tree, the user presses `a` and enters `notes.md`
- **THEN** `notes.md` is created in that folder and shows in the tree

#### Scenario: New folder
- **WHEN** the user presses `a` and enters `docs/`
- **THEN** a folder `docs` is created and shows in the tree

### Requirement: Rename, move, copy and delete
From the tree, the user SHALL be able to rename (`r`), move (`m`), copy (`c`) and delete (`d`) the file or folder under the cursor. Delete SHALL ask for confirmation and SHALL send the item to the system Recycle Bin rather than remove it permanently.

#### Scenario: Rename
- **WHEN** the user presses `r` on a file and enters a new name
- **THEN** the file is renamed on disk and in the tree

#### Scenario: Delete asks first
- **WHEN** the user presses `d` on a file
- **THEN** a confirmation is shown, and only after confirming is the file moved to the Recycle Bin

### Requirement: Preview from the tree
The tree SHALL show a preview of the file under the cursor as soon as it opens, following the cursor while it stays in the tree. `P` SHALL hide and show the preview.

#### Scenario: Preview on open
- **WHEN** the user opens the tree and moves the cursor onto a file
- **THEN** that file's content is shown in the preview while the cursor stays in the tree

#### Scenario: Toggle the preview
- **WHEN** the preview is shown and the user presses `P`
- **THEN** the preview is hidden, and pressing `P` again shows it

### Requirement: The tree shows git and diagnostic status
The tree SHALL mark files and folders that have git changes, and files that have diagnostics.

#### Scenario: Changed file
- **WHEN** a file in a git repo has uncommitted changes and the tree is open
- **THEN** the file is marked with its git status in the tree

### Requirement: Sidebar alternative
In standalone Neovim, `<leader>fE` SHALL open the same file tree as a sidebar on the right side of the screen, with the cursor in it. Confirming a file SHALL open it in the editor window and keep the sidebar open. The other tree requirements (file operations, marks, picker and terminal keys) SHALL apply to it. `<leader>fE` or `<leader>fe` SHALL close an open tree.

#### Scenario: Open the sidebar
- **WHEN** no file tree is open and the user presses `<leader>fE` in normal mode
- **THEN** a sidebar opens on the right showing the cwd's tree with the cursor on the current file

#### Scenario: Opening a file keeps the sidebar
- **WHEN** the cursor is on a file in the sidebar and the user presses `<CR>`
- **THEN** the file opens in the editor window and the sidebar stays open

#### Scenario: Close the sidebar
- **WHEN** the sidebar is open and the user presses `<leader>fE`
- **THEN** the sidebar closes

### Requirement: Sidebar preview in the editor window
In the sidebar, the preview of the file under the cursor SHALL be shown by default in the main editor window and follow the cursor, and `P` SHALL hide and show it.

#### Scenario: Preview on open
- **WHEN** the user opens the sidebar with `<leader>fE`
- **THEN** the editor window shows the preview of the file under the cursor, and moving the cursor updates it

### Requirement: The tree keeps the picker and terminal keys
In the tree, `Ctrl+c` and `q` SHALL close it, `<Esc>` SHALL NOT close it, and `<C-t>` SHALL toggle the terminal panel as it does elsewhere.

#### Scenario: Ctrl+c closes
- **WHEN** the cursor is in the tree and the user presses `Ctrl+c`
- **THEN** the tree closes and the working directory is unchanged

#### Scenario: Esc does not close
- **WHEN** the cursor is in the tree and the user presses `<Esc>`
- **THEN** the tree stays open

#### Scenario: Terminal toggle
- **WHEN** the cursor is in the tree and the user presses `<C-t>`
- **THEN** terminal 1 is shown and focused, as with `<leader>tt`

### Requirement: The tree loads on demand and is absent in VSCode mode
The file tree SHALL NOT add startup work or messages, and SHALL NOT be set up in VSCode mode, where `<leader>fe` keeps focusing VSCode's own explorer.

#### Scenario: Headless startup
- **WHEN** `pwsh ./gates.ps1 build` is run
- **THEN** the gate prints `BUILD_EXIT:0`

#### Scenario: VSCode mode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** `<leader>fe` runs VSCode's "focus file explorer" command and no file tree is set up
