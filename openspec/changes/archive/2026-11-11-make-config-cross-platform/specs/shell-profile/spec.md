# Spec Delta

## Purpose

Keeps the user's shell profiles in this repo so the prompt and the everyday aliases are the same in PowerShell
on Windows and in zsh on Linux (WSL or native), and so a new machine gets them from a clone.

## ADDED Requirements

### Requirement: zsh profile in the repo
The repo SHALL contain a zsh profile at `shell/.zshrc`, installed by linking `~/.zshrc` to it, so edits in
the repo are the live profile without a copy step.

#### Scenario: Profile is the repo file
- **WHEN** `~/.zshrc` is a link to the repo's `shell/.zshrc` and a new zsh starts
- **THEN** the profile's aliases are available and editing the repo file changes the next shell's profile

### Requirement: Same aliases in both profiles
The zsh profile SHALL provide the PowerShell profile's aliases with the same names and effect: `nconfig` goes to the Neovim config folder, `nvc` starts Neovim restoring the project's session, `nvimf` opens Neovim on the current folder, `desk` and `doc` go to the Desktop and Documents folders, and `phelp` lists them. `sprofile` is PowerShell-only.

#### Scenario: Go to the config
- **WHEN** the user types `nconfig` in zsh
- **THEN** the working directory becomes the Neovim config folder (`~/.config/nvim`)

#### Scenario: Restore the session
- **WHEN** the user types `nvc` in zsh inside a project
- **THEN** Neovim starts and restores that project's saved session

#### Scenario: Help lists the aliases
- **WHEN** the user types `phelp` in zsh
- **THEN** each alias above is listed with a one-line description

### Requirement: Desktop and Documents in WSL are the Windows folders
Inside WSL, `desk` and `doc` SHALL go to the Windows user's Desktop and Documents folders. On native Linux they SHALL go to `~/Desktop` and `~/Documents`. Finding the Windows folders SHALL NOT slow down shell startup.

#### Scenario: desk in WSL
- **WHEN** the user types `desk` in zsh inside WSL
- **THEN** the working directory becomes the Windows Desktop folder under `/mnt/c/Users/<windows user>`

#### Scenario: Startup cost
- **WHEN** a new zsh starts inside WSL
- **THEN** no Windows process is started by the profile to find those folders

### Requirement: Same prompt in both profiles
The zsh profile SHALL use oh-my-posh with the same `ys` theme as the PowerShell profile. If oh-my-posh is not installed, zsh SHALL still start with its default prompt and no error.

#### Scenario: Prompt theme
- **WHEN** a new zsh starts with oh-my-posh installed
- **THEN** the prompt uses the `ys` theme

#### Scenario: oh-my-posh missing
- **WHEN** a new zsh starts and `oh-my-posh` is not on `PATH`
- **THEN** zsh starts with no error message and the aliases still work
