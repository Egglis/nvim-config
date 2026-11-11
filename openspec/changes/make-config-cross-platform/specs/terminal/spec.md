# Spec Delta

## MODIFIED Requirements

### Requirement: Toggle a terminal panel
In standalone Neovim, the config SHALL provide a normal-mode key `<leader>tt` that opens a terminal panel running the configured shell in Neovim's current working directory, docked at the bottom of the editor by default, and focuses it in terminal mode.

#### Scenario: Open the terminal
- **WHEN** the user presses `<leader>tt` in normal mode with no terminal panel visible
- **THEN** a terminal panel opens at the bottom of the editor, running the configured shell (pwsh on Windows, the login shell on Linux) in Neovim's cwd, and the cursor is in it in terminal mode

#### Scenario: Focus a visible terminal
- **WHEN** the terminal panel is visible but the cursor is in an editor window, and the user presses `<leader>tt`
- **THEN** the cursor moves into the terminal panel instead of hiding it

#### Scenario: Toggle from the terminal
- **WHEN** the terminal panel is focused in normal mode and the user presses `<leader>tt`
- **THEN** the panel is hidden
