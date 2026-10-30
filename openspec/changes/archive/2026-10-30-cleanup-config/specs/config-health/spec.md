# Spec Delta

## ADDED Requirements

### Requirement: Config starts on a machine with no plugins installed
Starting standalone Neovim with an empty plugin data directory SHALL NOT raise a Lua error from this configuration; plugin installation SHALL proceed and the next start SHALL be clean.

#### Scenario: Fresh plugin directory
- **WHEN** Neovim is started headless with `XDG_DATA_HOME` (or the Windows equivalent) pointing to an empty directory
- **THEN** no error originates from a module under `init.lua` or `lua/`, and plugins are installed

#### Scenario: Second start after fresh install
- **WHEN** Neovim is started again with the same data directory
- **THEN** startup completes with no error message

### Requirement: Startup prints no informational messages
Neither standalone Neovim nor VSCode mode SHALL print informational messages from this configuration during startup.

#### Scenario: Standalone startup is silent
- **WHEN** standalone Neovim starts
- **THEN** `:messages` contains no message originating from this configuration

#### Scenario: VSCode startup is silent
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** no message originating from this configuration is printed
