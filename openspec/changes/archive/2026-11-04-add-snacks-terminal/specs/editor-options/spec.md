# Spec Delta

## ADDED Requirements

### Requirement: Shell is PowerShell 7
Standalone Neovim SHALL use pwsh 7 as its shell for `:terminal`, `:!`, `:make` and `system()`. Interactive terminals SHALL load the user's PowerShell profile; non-interactive shell commands SHALL run without it and SHALL return the command's exit code. VSCode mode SHALL leave the shell options untouched.

#### Scenario: Shell option
- **WHEN** standalone Neovim has started
- **THEN** `shell` is pwsh and `shellcmdflag` includes `-NoProfile` and `-Command`

#### Scenario: Bang command runs in pwsh
- **WHEN** the user runs `:!$PSVersionTable.PSVersion.Major`
- **THEN** the output is `7` (or higher) and no profile prompt or oh-my-posh output appears

#### Scenario: Exit code is preserved
- **WHEN** `vim.fn.system("exit 3")` is called
- **THEN** `vim.v.shell_error` is 3

#### Scenario: Interactive terminal loads the profile
- **WHEN** the user opens a terminal and types `nconfig`
- **THEN** the profile alias works and the cwd becomes the Neovim config folder

#### Scenario: VSCode mode untouched
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** `shell` keeps Neovim's default value
