# repo-accent Specification

## Purpose
TBD - created by archiving change add-repo-accent-color. Update Purpose after archive.

## Requirements

### Requirement: Repo detection
Standalone Neovim SHALL treat the nearest ancestor of the current working directory that contains `.git`
as the current repo, and SHALL re-evaluate it whenever the working directory changes.

#### Scenario: Started inside a repo
- **WHEN** standalone Neovim starts with its working directory inside a git repository
- **THEN** the current repo is that repository's root directory

#### Scenario: Directory change
- **WHEN** the working directory changes to a different repository with `:cd`
- **THEN** the current repo, accent and title update to the new repository

#### Scenario: Not in a repo
- **WHEN** the working directory is not inside any git repository
- **THEN** there is no current repo, no accent is shown, and the title is the folder name

### Requirement: Accent color from VSCode settings
When the repo has a `.vscode/settings.json` whose `workbench.colorCustomizations` sets
`statusBar.background` or `titleBar.activeBackground` to a `#rrggbb` color, that color SHALL be the
accent, with `statusBar.background` taking precedence. The file SHALL be read as VSCode reads it:
`//` and `/* */` comments and trailing commas are allowed.

#### Scenario: Status bar color set
- **WHEN** the repo's settings contain `"statusBar.background": "#700202"` in `workbench.colorCustomizations`
- **THEN** the accent is `#700202`

#### Scenario: Only title bar color set
- **WHEN** the settings set only `titleBar.activeBackground` to `#205020`
- **THEN** the accent is `#205020`

#### Scenario: Settings with comments and trailing commas
- **WHEN** the settings file contains `//` comments and trailing commas, as in a typical VSCode file
- **THEN** the color is still read correctly

#### Scenario: Unreadable settings
- **WHEN** the settings file is missing, malformed, or sets no usable color
- **THEN** no error is shown and the derived accent is used instead

### Requirement: Derived accent color
When the repo has no accent from VSCode settings, the accent SHALL be chosen from a fixed palette of
tokyonight colors by a stable hash of the repo folder name, so the same repo always gets the same color.

#### Scenario: Stable across sessions
- **WHEN** the same repo is opened in two separate Neovim sessions
- **THEN** both show the same accent color

### Requirement: Accent shown only in the chrome
The accent SHALL color only the statusline and the top bar; the colorscheme and the editing area SHALL be
unchanged, and every foreground on the accent or tint SHALL be chosen for readability.

#### Scenario: Statusline block
- **WHEN** standalone Neovim is inside a repo
- **THEN** the statusline starts with the repo name on the accent color, and the colorscheme is still tokyonight `night`

### Requirement: Tinted statusline
Inside a repo, the rest of the statusline (lualine sections b, c, x, y, in every mode) SHALL use a strong
tint of the accent as background; the mode section keeps its theme color.

#### Scenario: Tinted statusline
- **WHEN** standalone Neovim is inside a repo
- **THEN** the statusline's middle sections have a background that is a blend of the accent and the statusline background

### Requirement: Top bar
Inside a repo, a full-width top bar (tabline) SHALL be shown on the full accent with the repo name centred.
Outside a repo, the statusline SHALL use the plain theme and the top bar SHALL NOT be shown.

#### Scenario: Top bar
- **WHEN** standalone Neovim is inside a repo
- **THEN** `showtabline` is 2 and the tabline is a full-width bar on the accent color with the repo name

#### Scenario: Leaving a repo
- **WHEN** the working directory changes to a folder outside any git repository
- **THEN** the statusline uses the untinted theme and `showtabline` is back to 1

### Requirement: Terminal title names the repo
Standalone Neovim SHALL set the terminal title to the repo folder name (or the working directory's
folder name outside a repo), so the terminal's tab or window title identifies the repo.

#### Scenario: Title inside a repo
- **WHEN** standalone Neovim is running in the `nvim` repo
- **THEN** `title` is on and the title shown is `nvim`

### Requirement: VSCode mode unaffected
The repo accent and title SHALL NOT be set up when running inside VSCode.

#### Scenario: VSCode mode
- **WHEN** Neovim runs under vscode-neovim
- **THEN** no repo accent autocommands exist and `title` is unchanged
