# Spec Delta

## MODIFIED Requirements

### Requirement: Rename, move, copy and delete
From the tree, the user SHALL be able to rename (`r`), move (`m`), copy (`c`) and delete (`d`) the file or folder under the cursor. Delete SHALL ask for confirmation and SHALL send the item to the system trash rather than remove it permanently: the Recycle Bin on Windows, the freedesktop trash (`~/.local/share/Trash`) on Linux, including WSL.

#### Scenario: Rename
- **WHEN** the user presses `r` on a file and enters a new name
- **THEN** the file is renamed on disk and in the tree

#### Scenario: Delete asks first
- **WHEN** the user presses `d` on a file
- **THEN** a confirmation is shown, and only after confirming is the file moved to the system trash

#### Scenario: Delete on Windows
- **WHEN** the user confirms a delete in standalone Neovim on Windows
- **THEN** the file is in the Recycle Bin and can be restored from there

#### Scenario: Delete on Linux
- **WHEN** the user confirms a delete in standalone Neovim on Linux or WSL
- **THEN** the file is in the freedesktop trash (`trash-list` shows it) and `trash-restore` can bring it back
