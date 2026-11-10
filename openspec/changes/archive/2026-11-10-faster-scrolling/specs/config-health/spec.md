# Spec Delta

## ADDED Requirements

### Requirement: Config targets Neovim 0.12 or later
The config SHALL run on Neovim 0.12 or later, and the dependency check SHALL fail when the installed Neovim is older than 0.12.

#### Scenario: Version check
- **WHEN** `pwsh ./gates.ps1 deps` is run with Neovim 0.11 installed
- **THEN** it reports Neovim as too old and does not print `DEPS_EXIT:0`

#### Scenario: Current version
- **WHEN** `pwsh ./gates.ps1 deps` is run with Neovim 0.12.6 and every other tool installed
- **THEN** it prints `DEPS_EXIT:0`
