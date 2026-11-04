# Spec Delta

## Purpose

Gives standalone Neovim a toggleable terminal panel for running project commands such as `dotnet`, with the same `<leader>t…` keys as the VSCode setup, without slowing startup or affecting VSCode mode.

## ADDED Requirements

### Requirement: Toggle a terminal panel
In standalone Neovim, the config SHALL provide a normal-mode key `<leader>tt` that opens a terminal panel running the configured shell in Neovim's current working directory, docked at the bottom of the editor by default, and focuses it in terminal mode.

#### Scenario: Open the terminal
- **WHEN** the user presses `<leader>tt` in normal mode with no terminal panel visible
- **THEN** a terminal panel opens at the bottom of the editor, running pwsh in Neovim's cwd, and the cursor is in it in terminal mode

#### Scenario: Focus a visible terminal
- **WHEN** the terminal panel is visible but the cursor is in an editor window, and the user presses `<leader>tt`
- **THEN** the cursor moves into the terminal panel instead of hiding it

#### Scenario: Toggle from the terminal
- **WHEN** the terminal panel is focused in normal mode and the user presses `<leader>tt`
- **THEN** the panel is hidden

### Requirement: Hiding keeps the terminal running
Hiding the terminal panel SHALL NOT stop its shell process; reopening it SHALL show the same session with its scrollback and any process still running.

#### Scenario: Long-running command survives hide
- **WHEN** the user starts `dotnet watch` in the terminal, hides the panel, and presses `<leader>tt` again
- **THEN** the same terminal reappears with `dotnet watch` still running and its earlier output visible

### Requirement: Multiple numbered terminals
A count before `<leader>tt` SHALL select a terminal by number, so separate terminals can run side by side; without a count the key SHALL use terminal 1.

#### Scenario: Second terminal
- **WHEN** terminal 1 is open and the user presses `2<leader>tt` from an editor window
- **THEN** a separate terminal 2 opens, and terminal 1's process keeps running

### Requirement: Move the terminal panel
In standalone Neovim, `<leader>tr` SHALL move the terminal panel to a vertical split on the right and `<leader>tb` SHALL move it back to the bottom. The chosen position SHALL apply to later toggles in the same Neovim session.

#### Scenario: Move right
- **WHEN** the terminal panel is open at the bottom and the user presses `<leader>tr` in normal mode
- **THEN** the same terminal, with its process and scrollback, is shown in a vertical split on the right

#### Scenario: Position is remembered
- **WHEN** the user has moved the terminal to the right, hidden it, and presses `<leader>tt`
- **THEN** it reopens on the right

#### Scenario: Move back to the bottom
- **WHEN** the terminal panel is on the right and the user presses `<leader>tb`
- **THEN** it is shown at the bottom

### Requirement: Leaving terminal mode
Inside the terminal panel, pressing `<Esc>` twice in quick succession SHALL switch to normal mode, a single `<Esc>` SHALL still reach the running program, and `q` in normal mode SHALL hide the panel.

#### Scenario: Double escape
- **WHEN** the user presses `<Esc>` twice quickly in terminal mode
- **THEN** the terminal window is in normal mode and the shell process is unaffected

#### Scenario: Hide with q
- **WHEN** the terminal panel is in normal mode and the user presses `q`
- **THEN** the panel is hidden and the shell keeps running

### Requirement: Terminal is loaded on demand
The terminal plugin SHALL NOT be loaded and no terminal process SHALL be started during Neovim startup; it SHALL load the first time a terminal key is used.

#### Scenario: Plain startup
- **WHEN** standalone Neovim starts and no terminal key has been used
- **THEN** the terminal plugin is not loaded and no shell process is started by the config

### Requirement: Terminal is absent in VSCode mode
When `vim.g.vscode` is set, the config SHALL NOT load the terminal plugin, and `<leader>tt`, `<leader>tr` and `<leader>tb` SHALL keep their VSCode mappings.

#### Scenario: VSCode mode
- **WHEN** Neovim runs inside VSCode via vscode-neovim and the user presses `<leader>tt`
- **THEN** VSCode's own terminal toggles and no Neovim terminal plugin is loaded
