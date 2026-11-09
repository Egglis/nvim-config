# Spec Delta

## MODIFIED Requirements

### Requirement: Terminal is loaded on demand
The terminal plugin SHALL NOT be loaded during Neovim startup, unless the start screen is shown, and no terminal process SHALL be started during Neovim startup in any case; the terminal SHALL start the first time a terminal key is used.

#### Scenario: Plain startup
- **WHEN** standalone Neovim starts with a file argument and no terminal key has been used
- **THEN** the terminal plugin is not loaded and no shell process is started by the config

#### Scenario: Start screen startup
- **WHEN** standalone Neovim starts with no arguments, so the start screen is shown, and no terminal key has been used
- **THEN** no shell process is started by the config
