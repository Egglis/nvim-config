# Proposal

## Why

Less-used shortcuts are easy to forget, and some motions are used badly out of habit (`jjjj` instead of a jump).
`<leader>fp`/`<leader>fc` already work as a searchable cheatsheet. What's missing is a hint while typing, plus
help for practising better motions, and each of these should be easy to turn on and off.

## What Changes

- Add **which-key.nvim** (classic preset): after a prefix like `<Space>`, a popup lists the next keys. Named
  groups for the existing `<leader>` prefixes (`f` find, `t` terminal, `g` git, `o` opencode, `b` buffers,
  `q` session, `n` .NET, `u` toggles).
- Add **precognition.nvim** (motion hints such as `w`/`b`/`e`/`$` shown in the buffer) and **hardtime.nvim**
  (blocks repeated `hjkl` and similar, and suggests a better motion).
- Toggle keys under a new `<leader>u` group: `<leader>uw` which-key, `<leader>up` precognition, `<leader>uh`
  hardtime. Each toggle shows an on/off notification.
- Defaults: which-key on, precognition and hardtime off. A toggle is **remembered across restarts**.
- Standalone only; VSCode mode is unchanged.

## Capabilities

### New Capabilities
- `key-hints`: which-key popup, precognition and hardtime, their toggle keys, defaults and the saved state.

### Modified Capabilities
None.

## Impact

- New plugin specs in `lua/plugins/`, a small state module in `lua/config/`, three new entries in
  `lazy-lock.json`.
- Docs: `AGENTS.md` (keymaps, plugins), `readme.md` TODO ticks.
- No new external tools.
