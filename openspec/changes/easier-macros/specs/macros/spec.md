# Spec Delta

## Purpose

Makes Vim macros easier to use in standalone Neovim without changing the default macro keys: shows when a
macro is being recorded, shows what each register holds before replaying it, and lets the user list, run
and edit saved macros.

## ADDED Requirements

### Requirement: Default macro keys are unchanged
This config SHALL NOT remap `q`, `Q`, `@` (in visual mode), or `@@`. Recording with `q{reg}`, replaying with `@{reg}`, `@@` and `Q` (with a count), and running a macro on each line of a linewise selection SHALL work as in plain Neovim, in standalone Neovim and in VSCode mode.

#### Scenario: Record and replay with built-in keys
- **WHEN** the user types `qq`, `A;<Esc>j`, `q` on the first of five lines, then `3Q`
- **THEN** the first four lines end with `;`

#### Scenario: Run on selected lines
- **WHEN** a macro is in register `q` and the user selects three lines with `V` and presses `Q`
- **THEN** the macro has run once on each selected line

### Requirement: Recording indicator
In standalone Neovim, while a macro is being recorded, the statusline SHALL show a highlighted block naming the register (e.g. `REC @q`), and SHALL stop showing it as soon as the recording ends. It SHALL not depend on the command line being visible.

#### Scenario: Recording shown
- **WHEN** the user presses `qa` in normal mode
- **THEN** the statusline shows `REC @a` without waiting for a redraw timer

#### Scenario: Recording ends
- **WHEN** the user then presses `q`
- **THEN** the statusline no longer shows the recording block

### Requirement: Register list when replaying
In standalone Neovim with the key-hints popup on, pressing `@` in normal mode SHALL show the registers that hold something together with their contents; pressing a register key SHALL run that register as a macro, exactly like `@{reg}` without the popup. With the popup off, `@{reg}` SHALL work as usual.

#### Scenario: See registers before replaying
- **GIVEN** the key-hints popup is on and register `q` holds a macro
- **WHEN** the user presses `@`
- **THEN** a popup lists the registers including `q` with its keys, and pressing `q` runs the macro

#### Scenario: Count still applies
- **WHEN** the user presses `3@q`
- **THEN** the macro runs three times

### Requirement: Macro picker
In standalone Neovim, `<leader>fm` SHALL open a picker listing the registers `a`–`z` that are not empty, each shown with its keys in readable form (e.g. `<Esc>`, `<CR>`) and a preview. Confirming an entry SHALL run that register as a macro in the window the picker was opened from. The picker SHALL follow the closing and on-demand loading rules of the other pickers.

#### Scenario: List macros
- **WHEN** register `q` holds `A;` followed by Escape, register `b` is empty, and the user presses `<leader>fm`
- **THEN** the picker lists `q` as `A;<Esc>` and does not list `b`

#### Scenario: Run from the picker
- **WHEN** the user selects `q` and presses `<CR>`
- **THEN** the picker closes and the macro runs once at the cursor in the original window

#### Scenario: No macros
- **WHEN** all registers `a`–`z` are empty and the user presses `<leader>fm`
- **THEN** the picker opens with no entries (or reports that there are none) and no error is raised

### Requirement: Edit a macro
From the macro picker, `<C-e>` SHALL open the selected register's keys in readable form in an editable float. Writing it (`:w`) SHALL store the edited keys back into that register, converting readable key names back to the keys they name; closing without writing SHALL leave the register unchanged.

#### Scenario: Fix a macro
- **WHEN** register `q` holds `A;<Esc>`, the user opens it with `<C-e>`, changes the text to `A,<Esc>j` and writes
- **THEN** register `q` holds `A,` followed by Escape and `j`, and `@q` appends `,` and moves down

#### Scenario: Discard edits
- **WHEN** the user edits the text and closes the float without writing
- **THEN** register `q` is unchanged

### Requirement: Macro helpers are absent in VSCode mode
When Neovim runs with `vim.g.vscode` set, this config SHALL define no `<leader>fm` mapping, no `@` register popup and no recording indicator.

#### Scenario: VSCode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** `maparg("<leader>fm", "n")` and `maparg("@", "n")` are empty
