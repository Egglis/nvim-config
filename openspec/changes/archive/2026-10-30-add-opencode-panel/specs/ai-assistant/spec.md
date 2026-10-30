## ADDED Requirements

### Requirement: OpenCode panel docked on the right
In standalone Neovim, the config SHALL provide an OpenCode chat panel (prompt input and conversation output) that opens as a vertical split on the right side of the editor, about 40% of the editor width, and a key to toggle it.

#### Scenario: Toggle the panel
- **WHEN** the user presses `<leader>og` in normal mode with the panel closed
- **THEN** the OpenCode panel opens on the right side of the editor

#### Scenario: Hide keeps the session
- **WHEN** the user presses `<leader>og` with the panel open, then presses it again
- **THEN** the panel closes and reopens showing the same session and conversation

### Requirement: New session in the current workspace
In standalone Neovim, the config SHALL provide a key that starts a new OpenCode session scoped to Neovim's current working directory and focuses its prompt.

#### Scenario: Start a new session
- **WHEN** the user presses `<leader>oI` in normal mode
- **THEN** a new OpenCode session is created for the current working directory, the panel opens on the right, and the prompt input is focused in insert mode

#### Scenario: Continue the current session
- **WHEN** the user presses `<leader>oi` in normal mode
- **THEN** the prompt input opens for the active session instead of creating a new one

### Requirement: Assistant is loaded on demand
The OpenCode plugin SHALL NOT be loaded, and no OpenCode server SHALL be started, during Neovim startup; it SHALL load the first time one of its keys or its command is used.

#### Scenario: Plain startup
- **WHEN** standalone Neovim starts and no OpenCode key or command has been used
- **THEN** the OpenCode plugin is not loaded and no `opencode` process is started by the config

### Requirement: Assistant is absent in VSCode mode
When `vim.g.vscode` is set, the config SHALL NOT define any OpenCode mapping or load the OpenCode plugin.

#### Scenario: VSCode mode
- **WHEN** Neovim runs inside VSCode via vscode-neovim
- **THEN** `<leader>og`, `<leader>oi` and `<leader>oI` are not mapped by the config
