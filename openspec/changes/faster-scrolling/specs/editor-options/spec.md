# Spec Delta

## ADDED Requirements

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
