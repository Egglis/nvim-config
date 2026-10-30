# lsp Specification

## Purpose
Defines language-server behaviour in standalone Neovim: which servers are installed and attached, the buffer-local LSP mappings, formatting, and how diagnostics are shown.

## Requirements

### Requirement: Configured servers are installed and attach
Every server in the config's server list SHALL be installed automatically and SHALL attach to buffers of its filetypes.

#### Scenario: Lua server attaches
- **WHEN** a `.lua` file in this repo is opened in standalone Neovim
- **THEN** `lua_ls` attaches to the buffer and knows about the `vim` global and the Neovim API

### Requirement: LSP mappings are buffer-local to attached buffers
When a server attaches, the config SHALL set the LSP mappings on that buffer only.

#### Scenario: Mappings on attach
- **WHEN** a server attaches to a buffer
- **THEN** that buffer has `<leader>rn`, `<leader>ca`, `<leader>gd`, `<leader>gr`, `<leader>gi`, `<leader>td`, `<leader>ds`, `<leader>ws`, `K`, `<C-k>` and `gD`, with the same actions as before this change

#### Scenario: No LSP mappings without a server
- **WHEN** a buffer has no attached server
- **THEN** none of the LSP mappings are defined for that buffer

### Requirement: Code actions are unfiltered
`<leader>ca` SHALL offer every code action the server returns for the cursor position.

#### Scenario: All kinds offered
- **WHEN** the server returns code actions of any kind
- **THEN** all of them appear in the selection list

### Requirement: Format command
Buffers with an attached server SHALL have a `:Format` command that formats the buffer through the LSP.

#### Scenario: Format a Lua buffer
- **WHEN** the user runs `:Format` in a buffer with `lua_ls` attached
- **THEN** the buffer is formatted by the server

### Requirement: Diagnostics are visible inline
Diagnostics SHALL be shown as inline virtual text and as signs in the sign column, with severity ordering.

#### Scenario: Error shown inline
- **WHEN** a buffer contains an error reported by the server
- **THEN** the error message appears as virtual text on its line and a sign appears in the sign column

### Requirement: Completion sources
Insert-mode completion SHALL offer items from the LSP, file paths and the current buffers, and SHALL expand LSP snippet items.

#### Scenario: Snippet item expands
- **WHEN** the user confirms a snippet completion item from the LSP
- **THEN** the snippet body is inserted with its placeholders available for jumping
