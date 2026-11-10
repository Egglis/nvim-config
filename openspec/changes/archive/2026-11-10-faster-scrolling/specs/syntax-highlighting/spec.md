# Spec Delta

## Purpose

Defines how standalone Neovim colours source files: which languages use tree-sitter highlighting, how
their parsers get installed, and what happens when a parser is missing, without slowing startup or
affecting VSCode mode.

## ADDED Requirements

### Requirement: Tree-sitter highlighting for the configured languages
In standalone Neovim, buffers of the filetypes `cs`, `xml`, `json`, `ps1` and `python` SHALL be highlighted with tree-sitter instead of regex syntax highlighting, once their parser is installed. Filetypes that Neovim ships a parser for (Lua, Markdown, Vimscript, help) SHALL keep tree-sitter highlighting.

#### Scenario: C# file
- **WHEN** a `.cs` file is opened in standalone Neovim with the C# parser installed
- **THEN** the buffer is highlighted by tree-sitter and regex syntax highlighting is not active for it

#### Scenario: Each configured language
- **WHEN** a `.csproj`, `appsettings.json`, `.ps1` or `.py` file is opened with its parser installed
- **THEN** that buffer is highlighted by tree-sitter

#### Scenario: Bundled language kept
- **WHEN** a `.lua` file is opened
- **THEN** the buffer is highlighted by tree-sitter, as before this change

### Requirement: Parsers install automatically
The parsers for the configured languages SHALL be installed without a manual command when standalone Neovim starts and one is missing, and SHALL be updated when the plugin that provides them is updated.

#### Scenario: Missing parser
- **WHEN** standalone Neovim starts and the JSON parser is not installed
- **THEN** it is installed in the background, and a `.json` file opened after the install finishes is highlighted by tree-sitter

### Requirement: Missing parser falls back quietly
Opening a file whose parser is not installed (yet, or because its install failed) SHALL NOT raise an error; the buffer SHALL keep regex syntax highlighting.

#### Scenario: Parser not installed
- **WHEN** a `.py` file is opened while the Python parser is not installed
- **THEN** no error is shown and the buffer has regex syntax highlighting

### Requirement: MSBuild files are XML
Files with the extensions `.props` and `.targets` SHALL get the `xml` filetype in standalone Neovim, so they are highlighted like `.csproj` files.

#### Scenario: Props file
- **WHEN** a file named `Common.props` is opened
- **THEN** its filetype is `xml`

### Requirement: Highlighting adds no startup errors or prompts
Setting up tree-sitter highlighting SHALL NOT add errors or messages to startup, including on a machine with no plugins or parsers installed yet, and SHALL NOT run in VSCode mode.

#### Scenario: Headless startup
- **WHEN** `pwsh ./gates.ps1 build` is run
- **THEN** the gate prints `BUILD_EXIT:0`

#### Scenario: VSCode mode
- **WHEN** Neovim starts with `vim.g.vscode` set
- **THEN** no parser install starts and no tree-sitter highlighting is set up by this config
