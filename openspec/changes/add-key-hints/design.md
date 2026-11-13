# Design

## Context

Plugins are one file per spec in `lua/plugins/`; snacks is already loaded lazily and provides `Snacks.toggle`.
Startup must stay silent and work on a fresh install (no plugin `require` outside plugin config/functions).

## Goals / Non-Goals

**Goals:** three helpers, one toggle key each, state saved across restarts, minimal config.

**Non-Goals:** a cheatsheet (`<leader>fp`/`<leader>fc` already do it), which-key in VSCode, tuning hardtime's
rules beyond the defaults, per-project state.

## Decisions

1. **Files.** `lua/plugins/which-key.lua`, `lua/plugins/precognition.lua`, `lua/plugins/hardtime.lua`, and
   `lua/config/key_hints.lua` for the saved state and the toggles.
2. **Saved state.** `stdpath("state")/key-hints.json`, e.g. `{"whichkey":true,"precognition":false,"hardtime":false}`.
   Read with `pcall(vim.json.decode)`; a missing/broken file or key falls back to the default. Written on each
   toggle. Not tied to the session files.
3. **Toggles.** `Snacks.toggle.new({ name, get, set })` mapped to `<leader>uw/up/uh` (gives the on/off
   notification). The keys are lazy `keys` on each plugin spec, so pressing one loads the plugin if needed.
4. **Loading.** which-key loads on `VeryLazy`. precognition and hardtime load on `VeryLazy` only when saved
   on, otherwise on their toggle key. Start state comes from the file: precognition `startVisible`, hardtime
   `enabled`.
5. **which-key off.** which-key has no disable API, so `delay` is a function returning a huge value while
   off: triggers stay, the popup never shows, keys work as before. Groups via `spec` in opts
   (`<leader>f` find, `t` terminal, `g` git, `o` opencode, `b` buffers, `q` session, `n` .NET, `u` toggles).
   Classic preset.
6. **hardtime.** Defaults, except `disable_mouse = false` (the default disables the mouse while it runs) and
   snacks picker/explorer/terminal/lazygit filetypes added to `disabled_filetypes`. Toggle via
   `require("hardtime").enable()/disable()`.
7. **precognition.** Defaults; toggle with `require("precognition").show()/hide()`.

## Risks / Trade-offs

- hardtime remaps keys like `j`/`k`/arrows while on; its mappings come from the plugin and may lack `desc`.
  The "every mapping has a description" check covers mappings defined by this config, so verify the test
  doesn't trip on them (exclude or note it).
- which-key's trigger mappings can change how `timeoutlen` feels on prefixes; check `<leader>g…` and
  `<leader>t…` still work without waiting.
- Exact option/API names are from the current plugin versions; confirm when implementing.
