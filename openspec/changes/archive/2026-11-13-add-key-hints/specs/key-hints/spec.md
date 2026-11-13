# Spec Delta

## Purpose

Helps the user remember and practise keys in standalone Neovim: a popup of next keys while typing, motion
hints in the buffer, and a habit trainer, each with its own toggle key and a state that survives restarts.

## ADDED Requirements

### Requirement: Next-key popup
In standalone Neovim, after a key prefix that has mappings under it (e.g. `<leader>`) and a short pause, a
popup SHALL list the possible next keys with their descriptions, and `<leader>` prefixes SHALL show group names.

#### Scenario: Leader popup
- **GIVEN** the popup is on
- **WHEN** the user presses `<leader>` and waits
- **THEN** a popup lists the next keys, including the groups `f`, `t`, `g`, `o`, `b`, `q`, `n` and `u` with names

#### Scenario: Popup off
- **GIVEN** the popup is toggled off
- **WHEN** the user presses `<leader>` and waits
- **THEN** no popup appears and `<leader>` mappings still work

### Requirement: Motion hints
In standalone Neovim, when motion hints are on, the buffer SHALL show hints for nearby motions (such as `w`,
`b`, `e`, `$`) around the cursor; when off, no hints are shown.

#### Scenario: Hints shown
- **GIVEN** motion hints are on
- **WHEN** the cursor is in a file buffer
- **THEN** motion hints are shown for the cursor line

### Requirement: Habit trainer
In standalone Neovim, when the habit trainer is on, repeating a basic motion key (such as `j`) many times in
a row SHALL be blocked with a hint suggesting a better motion; when off, keys behave normally.

#### Scenario: Repeated j blocked
- **GIVEN** the habit trainer is on
- **WHEN** the user presses `j` repeatedly in quick succession in a file buffer
- **THEN** further presses are blocked and a hint is shown

#### Scenario: Pickers unaffected
- **GIVEN** the habit trainer is on
- **WHEN** the user moves with `j`/`k` in a picker, the explorer, a terminal or lazygit
- **THEN** the keys are not blocked

### Requirement: Toggle keys
Standalone Neovim SHALL provide `<leader>uw` (next-key popup), `<leader>up` (motion hints) and `<leader>uh`
(habit trainer); each flips its helper and shows a notification with the new state.

#### Scenario: Toggle motion hints
- **GIVEN** motion hints are off
- **WHEN** the user presses `<leader>up`
- **THEN** motion hints turn on and a notification says so

#### Scenario: VSCode untouched
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** none of the three helpers is loaded and `<leader>uw`, `<leader>up`, `<leader>uh` are not mapped

### Requirement: Defaults and saved state
On first use the next-key popup SHALL be on and motion hints and the habit trainer off. Each toggle SHALL be
saved, and the next start SHALL use the saved states.

#### Scenario: First start
- **GIVEN** no saved state exists
- **WHEN** standalone Neovim starts
- **THEN** the popup is on, motion hints and the habit trainer are off

#### Scenario: State survives a restart
- **GIVEN** the user turned the habit trainer on and the popup off
- **WHEN** Neovim is restarted
- **THEN** the habit trainer is on and the popup is off

#### Scenario: Broken state file
- **GIVEN** the saved state file is unreadable or not valid
- **WHEN** standalone Neovim starts
- **THEN** the defaults apply and startup shows no error
