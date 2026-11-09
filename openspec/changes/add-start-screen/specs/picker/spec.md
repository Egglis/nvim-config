# Spec Delta

## MODIFIED Requirements

### Requirement: Pickers load on demand
The picker plugin SHALL NOT be loaded during Neovim startup, unless the start screen is shown; it SHALL load the first time a picker key, an LSP list key or a selection list is used. When Neovim is started with a file or directory argument, the picker plugin SHALL stay unloaded until then.

#### Scenario: Plain startup
- **WHEN** standalone Neovim starts with a file argument and no picker has been used
- **THEN** the picker plugin is not loaded

#### Scenario: Start screen startup
- **WHEN** standalone Neovim starts with no arguments, so the start screen is shown
- **THEN** the picker plugin may be loaded, and every picker key works as usual
