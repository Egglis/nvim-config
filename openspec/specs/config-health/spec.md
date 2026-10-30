# config-health Specification

## Purpose
Keeps the Neovim configuration in a state that can be checked automatically: it starts cleanly and its Lua source has one consistent format.

## Requirements

### Requirement: Config starts without errors
Starting standalone Neovim with this configuration SHALL complete without any startup error message.

#### Scenario: Headless startup is clean
- **WHEN** `pwsh ./gates.ps1 build` is run
- **THEN** Neovim loads `init.lua` with no error and the gate prints `BUILD_EXIT:0`

#### Scenario: Clipboard uses the system register
- **WHEN** standalone Neovim has started
- **THEN** the `clipboard` option is `unnamedplus`

### Requirement: Lua source follows the repo formatting standard
All Lua files in `init.lua` and `lua/` SHALL match the formatting standard defined in the repo's formatter config file, so the editor and the gate use the same settings.

#### Scenario: Format check passes
- **WHEN** `pwsh ./gates.ps1 format` is run
- **THEN** no file is reported as differing and the gate prints `FORMAT_EXIT:0`

#### Scenario: Formatter config is the single source
- **WHEN** someone runs `stylua` from the repo root without extra flags
- **THEN** it produces the same output the format gate checks against

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
