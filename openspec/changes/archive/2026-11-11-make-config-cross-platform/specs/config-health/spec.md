# Spec Delta

## MODIFIED Requirements

### Requirement: Config starts without errors
Starting standalone Neovim with this configuration SHALL complete without any startup error message, on Windows and on Linux (including WSL).

#### Scenario: Headless startup is clean
- **WHEN** `pwsh ./gates.ps1 build` is run on Windows, or `./gates.sh build` on Linux
- **THEN** Neovim loads `init.lua` with no error and the gate prints `BUILD_EXIT:0`

#### Scenario: Clipboard uses the system register
- **WHEN** standalone Neovim has started
- **THEN** the `clipboard` option is `unnamedplus`

### Requirement: Lua source follows the repo formatting standard
All Lua files in `init.lua` and `lua/` SHALL match the formatting standard defined in the repo's formatter config file, so the editor and the gate use the same settings.

#### Scenario: Format check passes
- **WHEN** `pwsh ./gates.ps1 format` is run on Windows, or `./gates.sh format` on Linux
- **THEN** no file is reported as differing and the gate prints `FORMAT_EXIT:0`

#### Scenario: Formatter config is the single source
- **WHEN** someone runs `stylua` from the repo root without extra flags
- **THEN** it produces the same output the format gate checks against

### Requirement: Config targets Neovim 0.12 or later
The config SHALL run on Neovim 0.12 or later, and the dependency check SHALL fail when the installed Neovim is older than 0.12, on Windows and on Linux.

#### Scenario: Version check
- **WHEN** `pwsh ./gates.ps1 deps` (Windows) or `./gates.sh deps` (Linux) is run with Neovim 0.11 installed
- **THEN** it reports Neovim as too old and does not print `DEPS_EXIT:0`

#### Scenario: Current version
- **WHEN** `pwsh ./gates.ps1 deps` (Windows) or `./gates.sh deps` (Linux) is run with Neovim 0.12.6 and every other tool installed
- **THEN** it prints `DEPS_EXIT:0`

## ADDED Requirements

### Requirement: Gates run on Linux
The repo SHALL provide `gates.sh`, runnable from bash on Linux (including WSL), with the same targets as `gates.ps1` (`build`, `format`, `validate`, `gates`, `changes`, `deps`). Each gate SHALL print the same `LABEL_EXIT:<n>` line and exit with the same code as its `gates.ps1` counterpart.

#### Scenario: All gates on Linux
- **WHEN** `./gates.sh gates` is run from the repo root in WSL with the config clean
- **THEN** it prints `BUILD_EXIT:0`, `FORMAT_EXIT:0`, `VALIDATE_EXIT:0` and `GATES_EXIT:0`, and exits 0

#### Scenario: A failing gate
- **WHEN** a Lua file is badly formatted and `./gates.sh gates` is run
- **THEN** it prints `FORMAT_EXIT:1`, still runs the other gates, prints `GATES_EXIT:1` and exits non-zero

#### Scenario: Unknown target
- **WHEN** `./gates.sh nope` is run
- **THEN** it lists the known targets and exits 2

### Requirement: Linux dependency check
`./gates.sh deps` SHALL check every tool `docs/dependencies.md` lists for Linux, print a `MISSING <tool> — <Fedora install command>` line for each one absent or too old, and print `DEPS_EXIT:0` only when none is missing. Inside WSL it SHALL also check for `win32yank.exe`.

#### Scenario: Tool missing
- **WHEN** `trash` is not installed and `./gates.sh deps` is run
- **THEN** it prints a `MISSING trash` line with the `dnf install trash-cli` command and `DEPS_EXIT:1`

#### Scenario: WSL-only check
- **WHEN** `./gates.sh deps` is run inside WSL without `win32yank.exe` on `PATH`
- **THEN** it reports `win32yank.exe` as missing; on native Linux the same check is skipped

### Requirement: Gate scripts work from either checkout
Shell scripts and the zsh profile SHALL be checked out with LF line endings on every platform, and `gates.sh` SHALL be executable in git.

#### Scenario: Windows checkout
- **WHEN** the repo is cloned on Windows with `core.autocrlf=true`
- **THEN** `gates.sh` and `shell/.zshrc` still have LF line endings
