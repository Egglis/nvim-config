# Spec Delta

## Purpose

Defines which key mappings exist in standalone Neovim and in VSCode (vscode-neovim), and keeps the VSCode path free of plugin dependencies.

## ADDED Requirements

### Requirement: Shared mappings exist in both environments
The config SHALL define the shared mappings in both standalone Neovim and VSCode mode, without loading any plugin.

#### Scenario: Shared mappings present
- **WHEN** Neovim starts in either environment
- **THEN** these normal-mode mappings exist: `<leader>y`, `<leader>p`, `<C-s>`, `<Esc>`, `<C-u>`, `<C-d>`, `B`, `E`, `<C-a>`, `Ø`, and visual-mode `<`, `>`, `<leader>y`, `<leader>p`, `B`, `E`

#### Scenario: Escape clears search highlight
- **WHEN** the user presses `<Esc>` in normal mode
- **THEN** any search highlight is cleared and no command text is echoed

### Requirement: VSCode mode loads no plugins
When `vim.g.vscode` is set, the config SHALL NOT load lazy.nvim or any plugin.

#### Scenario: No plugin manager in VSCode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** the `lazy` module is not loaded

### Requirement: VSCode mappings delegate to VSCode commands
In VSCode mode, the config SHALL define the VSCode mappings, each defined exactly once, and each SHALL invoke its VSCode command.

#### Scenario: VSCode mapping set
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** mappings exist for `K`, `J`, `<leader>pn`, `<leader>pp`, `<leader>fa`, `<leader>fd`, `<leader>ff`, `<leader>ku`, `<leader>kc`, `<leader>gr`, `<leader>fe`, `<leader>fg`, `<leader>ha`, `<leader>hh`, `<leader>he`, `<leader>h1` to `<leader>h9`, `<leader>le`, `<leader>ee`, `<leader>bb`, `<leader>tt`, `<leader>tr` and `<leader>tb`, with the same VSCode commands as before this change

### Requirement: Every mapping has a description
Every mapping defined by this config outside VSCode mode SHALL have a non-empty description. `lua/keymaps/vscode.lua` and `lua/keymaps/shared.lua` are excluded: the user keeps those files as written.

#### Scenario: Descriptions present
- **WHEN** standalone Neovim has started and the mappings defined by this config are listed with `nvim_get_keymap`
- **THEN** each has a non-empty `desc`

### Requirement: Standalone search pickers
In standalone Neovim, the config SHALL provide fuzzy pickers for files, live grep, open buffers and help tags.

#### Scenario: Picker mappings
- **WHEN** standalone Neovim has started
- **THEN** `<leader>ff` finds files, `<leader>fa` live-greps the project, `<leader>fb` lists buffers and `<leader>fh` searches help tags
