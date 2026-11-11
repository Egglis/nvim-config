# Spec Delta

## RENAMED Requirements

- FROM: `### Requirement: Shell is PowerShell 7`
- TO: `### Requirement: Shell matches the platform`

## MODIFIED Requirements

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

## ADDED Requirements

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
