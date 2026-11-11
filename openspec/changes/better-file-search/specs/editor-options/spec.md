## MODIFIED Requirements

### Requirement: Search behaviour
Search SHALL be incremental and case-insensitive unless the pattern contains an uppercase letter. In standalone Neovim, the matches of the last search SHALL stay highlighted until the highlight is cleared (`<Esc>` in normal mode or `:noh`). VSCode mode SHALL keep search highlighting off.

#### Scenario: Search settings
- **WHEN** Neovim has started
- **THEN** `incsearch`, `ignorecase` and `smartcase` are on

#### Scenario: Matches stay highlighted
- **WHEN** standalone Neovim has started and the user searches with `/foo<CR>`
- **THEN** `hlsearch` is on and every `foo` in the window is highlighted, and after `<Esc>` in normal mode none is

#### Scenario: VSCode keeps highlighting off
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** `hlsearch` is off

## ADDED Requirements

### Requirement: Search jumps stay centred
In standalone Neovim, `n` and `N` SHALL move to the next/previous match as before (including a count), then centre the match line in the window and open any fold containing it. VSCode mode SHALL keep the built-in `n`/`N`.

#### Scenario: Next match centred
- **WHEN** standalone Neovim has searched `/foo<CR>` in a long file and the user presses `n`
- **THEN** the cursor is on the next `foo` and that line is in the middle of the window

#### Scenario: Match in a fold
- **WHEN** the next match is inside a closed fold and the user presses `n`
- **THEN** the fold opens and the cursor is on the match

### Requirement: Search match count in the statusline
In standalone Neovim, while search highlighting is active the statusline SHALL show the current match's position and the total number of matches (e.g. `[3/7]`); it SHALL show nothing for search once the highlight is cleared.

#### Scenario: Count shown
- **WHEN** the user searches `/foo<CR>` in a buffer with 7 matches and the cursor lands on the 3rd
- **THEN** the statusline shows `[3/7]`

#### Scenario: Count cleared
- **WHEN** the user then presses `<Esc>` in normal mode
- **THEN** the statusline no longer shows a match count
