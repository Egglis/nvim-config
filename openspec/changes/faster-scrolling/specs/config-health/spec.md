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

### Requirement: Scroll cost can be measured on demand
The repo SHALL provide a scroll benchmark that measures the redraw time per cursor step in a real terminal UI, for a large generated C# file and a large generated Lua file, with the config's defaults and with each cursor-move setting (syntax highlighting, `relativenumber`, `cursorline`, bracket matching) turned off in turn. It SHALL NOT be part of the `gates` run.

#### Scenario: Run the benchmark
- **WHEN** `pwsh ./gates.ps1 bench` is run on the Windows desktop
- **THEN** it prints one line per file and setting with the milliseconds per step, then `BENCH_EXIT:0`

#### Scenario: Not in the gates
- **WHEN** `pwsh ./gates.ps1 gates` is run
- **THEN** no benchmark window opens
