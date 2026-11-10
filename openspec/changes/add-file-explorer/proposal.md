# Proposal

## Why

Standalone Neovim has no file tree. Files are found through the pickers (`<leader>ff`, `<leader>fr`),
but there is no way to see a project's folder structure, or to create, rename, move or delete files and
folders without leaving Neovim or typing paths. The readme has an open TODO for a simple file tree. VSCode
already has its explorer on `<leader>fe` through vscode-neovim.

## What Changes

- **File tree float** in standalone Neovim, using the explorer that comes with snacks.nvim (already
  installed for the pickers, terminal and start screen). No new plugin.
- `<leader>fe` toggles it, the same key that focuses the explorer in VSCode mode.
- It opens as a **centred float laid out like the git pickers** (tree and filter on one side, a preview
  of the file under the cursor on the other; stacked on narrow screens). It shows the tree of Neovim's cwd
  with git status and diagnostics, and follows the current file. The **preview is on by default**; `P`
  hides or shows it.
- Opening a file closes the float, like the other pickers; `<leader>fe` reopens it at that file.
- History: §1 built a right sidebar that stayed open on file open; after trying it, the user asked for
  the float with the preview on instead.
- Simple file operations from the tree, with snacks' default keys: add a file (`a`; a name ending in `/`
  makes a folder), rename (`r`), delete (`d`, asks first and uses the Recycle Bin), move (`m`), copy
  (`c`), yank and paste (`y`/`p`).
- It follows the existing picker and terminal conventions. `Ctrl+c` and `q` close it, and `<Esc>` doesn't.
  `<C-t>` stays the terminal toggle. snacks binds both `Ctrl+c` (change directory) and `<C-t>` (open a
  terminal) in the tree by default, and the config overrides those two.
- Plain icons: snacks' own file and folder glyphs. No icon plugin (the user's choice).

Out of scope: file-type icon plugins (`mini.icons`, devicons), LSP symbols in the tree, replacing netrw
(`nvim .` keeps opening as before), custom keys beyond the two overrides, and VSCode mode, which keeps
its own explorer.

## Capabilities

### New Capabilities
- `file-explorer`: the file tree float in standalone Neovim: how it opens and closes, where it sits,
  what it shows, the file operations it offers, and how it fits the picker and terminal keys.

### Modified Capabilities
None. The existing `picker` ("Closing a picker") and `terminal` ("One-key toggle from terminal mode")
requirements already cover the tree, and this change keeps to them.

## Impact

- Changed: `lua/plugins/snacks.lua` (a `<leader>fe` key and `opts.picker.sources.explorer`).
- No new plugin or dependency. snacks is already pinned in `lazy-lock.json`. Deleting uses PowerShell's
  Recycle Bin call, which snacks has built in for Windows.
- Docs: `AGENTS.md` (a "File explorer" section, the snacks plugin row, and the note on `<leader>fe` meaning
  differently in the two environments), and the readme TODO.
