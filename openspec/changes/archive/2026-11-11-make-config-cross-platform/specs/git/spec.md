# Spec Delta

## MODIFIED Requirements

### Requirement: Git lookup keys
In standalone Neovim, these normal-mode keys SHALL open git views of Neovim's cwd repo: `<leader>gs` changed files (stage and restore like `<leader>fg`), `<leader>gl` commit log, `<leader>gf` commits that changed the current file, `<leader>gb` branches (confirm checks one out), `<leader>gB` blame for the current line, `<leader>go` the current file on the remote's website.

#### Scenario: File history
- **WHEN** the user is in a tracked file and presses `<leader>gf`
- **THEN** a picker lists the commits that changed that file, with a preview of each commit's diff

#### Scenario: Switch branch
- **WHEN** the user presses `<leader>gb` and confirms another local branch
- **THEN** that branch is checked out

#### Scenario: Open on the remote
- **WHEN** the user presses `<leader>go` in a tracked file of a repo whose remote is on GitHub
- **THEN** the browser opens that file's page on GitHub

#### Scenario: Open on the remote from WSL
- **WHEN** Neovim runs inside WSL and the user presses `<leader>go` in a tracked file of a repo whose remote is on GitHub
- **THEN** the Windows default browser opens that file's page on GitHub, and Neovim shows no error

#### Scenario: LSP keys are kept
- **WHEN** an LSP server is attached and the user presses `<leader>gd`, `<leader>gr` or `<leader>gi`
- **THEN** the LSP definition, references or implementation picker opens, as before
