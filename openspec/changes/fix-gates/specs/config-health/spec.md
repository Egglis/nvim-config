# Spec Delta

## Purpose

Keeps the Neovim configuration in a state that can be checked automatically: it starts cleanly and its Lua source has one consistent format.

## ADDED Requirements

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
