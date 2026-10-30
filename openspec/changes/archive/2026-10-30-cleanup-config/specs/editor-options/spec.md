# Spec Delta

## Purpose

Defines the editor option defaults the config sets, so editing behaviour is predictable in both standalone Neovim and VSCode mode.

## ADDED Requirements

### Requirement: Indentation uses two spaces
The config SHALL set two-space indentation, using spaces rather than tabs.

#### Scenario: Indent settings
- **WHEN** Neovim has started
- **THEN** `tabstop`, `shiftwidth` and `softtabstop` are 2 and `expandtab` is on

### Requirement: Search behaviour
Search SHALL be incremental and case-insensitive unless the pattern contains an uppercase letter, without persistent highlighting.

#### Scenario: Search settings
- **WHEN** Neovim has started
- **THEN** `incsearch`, `ignorecase` and `smartcase` are on and `hlsearch` is off

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
