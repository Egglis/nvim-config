# editor-options Specification

## Purpose
Defines the editor option defaults the config sets, so editing behaviour is predictable in both standalone Neovim and VSCode mode.

## Requirements

### Requirement: Indentation uses two spaces
The config SHALL set two-space indentation, using spaces rather than tabs.

#### Scenario: Indent settings
- **WHEN** Neovim has started
- **THEN** `tabstop`, `shiftwidth` and `softtabstop` are 2 and `expandtab` is on

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

### Requirement: Window and display defaults
Standalone Neovim SHALL show absolute and relative line numbers, an always-visible sign column, a cursor line, 8 lines of scroll context, and SHALL open splits to the right and below.

#### Scenario: Display settings
- **WHEN** standalone Neovim has started
- **THEN** `number`, `relativenumber`, `cursorline`, `splitright` and `splitbelow` are on, `signcolumn` is `yes` and `scrolloff` is 8

### Requirement: Undo history persists
Standalone Neovim SHALL keep undo history across sessions.

#### Scenario: Undo after reopening
- **WHEN** a file is edited, saved, closed and reopened
- **THEN** `u` undoes the edit from the previous session

### Requirement: Timing defaults
The config SHALL set `updatetime` to 250 ms and `timeoutlen` to 300 ms.

#### Scenario: Timing settings
- **WHEN** Neovim has started
- **THEN** `updatetime` is 250 and `timeoutlen` is 300

### Requirement: Leader key
The leader and local leader SHALL be `<Space>`, set before any mapping is defined.

#### Scenario: Leader set
- **WHEN** Neovim has started in either environment
- **THEN** `mapleader` and `maplocalleader` are a single space

### Requirement: Shell matches the platform
On Windows, standalone Neovim SHALL use pwsh 7 as its shell for `:terminal`, `:!`, `:make` and `system()`. Interactive terminals SHALL load the user's PowerShell profile; non-interactive shell commands SHALL run without it and SHALL return the command's exit code. On Linux (including WSL), standalone Neovim SHALL keep Neovim's default shell options, so the user's login shell is used. VSCode mode SHALL leave the shell options untouched.

#### Scenario: Shell option
- **WHEN** standalone Neovim has started on Windows
- **THEN** `shell` is pwsh and `shellcmdflag` includes `-NoProfile` and `-Command`

#### Scenario: Bang command runs in pwsh
- **WHEN** the user runs `:!$PSVersionTable.PSVersion.Major` on Windows
- **THEN** the output is `7` (or higher) and no profile prompt or oh-my-posh output appears

#### Scenario: Exit code is preserved
- **WHEN** `vim.fn.system("exit 3")` is called on Windows or Linux
- **THEN** `vim.v.shell_error` is 3

#### Scenario: Interactive terminal loads the profile
- **WHEN** the user opens a terminal and types `nconfig`, on Windows or Linux
- **THEN** the profile alias works and the cwd becomes the Neovim config folder

#### Scenario: Linux uses the login shell
- **WHEN** standalone Neovim has started on Linux with zsh as the login shell
- **THEN** `shell` is the login shell (`$SHELL`), `shellcmdflag` is `-c`, and no PowerShell option is set

#### Scenario: VSCode mode untouched
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** `shell` keeps Neovim's default value

### Requirement: Cursor moves stay cheap
Standalone Neovim SHALL limit the work done on each cursor move: bracket matching SHALL search for at most 20 ms in normal mode and 20 ms in insert mode, and regex syntax highlighting SHALL stop at column 300 of a line.

#### Scenario: Bracket matching limit
- **WHEN** standalone Neovim has started
- **THEN** `g:matchparen_timeout` and `g:matchparen_insert_timeout` are 20, and bracket matching still highlights the pair when the cursor is on a bracket

#### Scenario: Long-line highlighting limit
- **WHEN** standalone Neovim has started
- **THEN** `synmaxcol` is 300

#### Scenario: VSCode mode untouched
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** `synmaxcol` and the bracket matching limits keep Neovim's defaults

### Requirement: WSL clipboard is the Windows clipboard
When standalone Neovim runs inside WSL, the `+` and `*` registers SHALL read and write the Windows clipboard through `win32yank.exe`, even when a Linux clipboard tool is also installed. Outside WSL, Neovim's own clipboard provider choice SHALL apply.

#### Scenario: Yank in WSL, paste in Windows
- **WHEN** the user yanks a line in standalone Neovim inside WSL and pastes in a Windows app
- **THEN** the Windows app pastes that line, with no extra carriage returns

#### Scenario: Copy in Windows, paste in WSL
- **WHEN** the user copies text in a Windows app and presses `p` in standalone Neovim inside WSL
- **THEN** the copied text is pasted without trailing `^M` characters

#### Scenario: Provider in WSL
- **WHEN** standalone Neovim has started inside WSL with `win32yank.exe` on `PATH`
- **THEN** `:checkhealth vim.provider` reports `win32yank` as the clipboard tool

#### Scenario: win32yank missing
- **WHEN** standalone Neovim starts inside WSL and `win32yank.exe` is not on `PATH`
- **THEN** startup has no error and Neovim falls back to its own clipboard provider choice

### Requirement: WSL opens URLs in the Windows browser
When standalone Neovim runs inside WSL, opening a URL (`gx`, `:Open`, or a key that opens a web page) SHALL open it in the Windows default browser, without a Linux browser or `wslu` installed.

#### Scenario: Open a URL
- **WHEN** the cursor is on `https://neovim.io` in standalone Neovim inside WSL and the user presses `gx`
- **THEN** the page opens in the Windows default browser and Neovim shows no error

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
