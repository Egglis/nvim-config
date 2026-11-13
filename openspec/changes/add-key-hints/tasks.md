# Tasks

## 1. Saved state and which-key

- [x] 1.1 `lua/config/key_hints.lua`: read/write `stdpath("state")/key-hints.json` with defaults (design 2). Verify headless: no file → `{whichkey=true, precognition=false, hardtime=false}`; a garbage file → defaults, no error; after a set, the file holds the new value
- [x] 1.2 `lua/plugins/which-key.lua`: classic preset, group names, `delay` honouring the saved state, `<leader>uw` toggle via `Snacks.toggle` (design 3–5). Verify headless: the plugin loads after `VeryLazy`; `<leader>` groups `f t g o b q n u` have names; toggling flips the state file; `vim.g.vscode` start doesn't load it; startup prints nothing; `./gates.sh gates` → `GATES_EXIT:0`

## 2. precognition and hardtime

- [x] 2.1 `lua/plugins/precognition.lua` with `<leader>up` (design 4, 7). Verify headless: off by default and not loaded; `<leader>up` loads and shows hints and saves `true`; a restart with `true` shows hints on start
- [x] 2.2 `lua/plugins/hardtime.lua` with `<leader>uh`, `disable_mouse = false`, snacks filetypes disabled (design 4, 6). Verify headless: off by default and not loaded; `<leader>uh` enables and saves; restart with `true` starts enabled; the description check still passes (design risk 1)
- [x] 2.3 Docs: `AGENTS.md` (new "Key hints" keymaps section, plugin rows, `lua/config/key_hints.lua` in the tree), `readme.md` tick "Key guidance" and "Remember less-used shortcuts". Verify: `./gates.sh gates` → `GATES_EXIT:0`

## 3. Human check

- [ ] 3.1 **Human check** with a recipe from the agent: `<Space>` popup and group names, `<leader>uw/up/uh` notifications, hardtime blocks `jjjj` in a file but not in pickers/explorer/terminal/lazygit, precognition hints visible, states kept after a restart, VSCode unchanged. Verify: answers recorded in a devlog note

## Workflow follow-up

- Whole-change review, change-done note, offer an independent review, then offer `/opsx-archive`.
