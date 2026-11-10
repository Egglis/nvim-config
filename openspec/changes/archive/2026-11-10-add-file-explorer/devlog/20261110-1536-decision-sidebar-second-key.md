# Human check passed; decision: keep the sidebar on `<leader>fE`

<!-- Section: 3 · Tasks: 3.1 -->

User's answer to the §3 recipe (`20261110-1532-stopped-human-check.md`): "It works fine, and I prefer the
float". 3.1 ticked.

Then: "keep the other version as well so I can toggle if I change my mind later". Answers:

- How to switch: a **second key**, `<leader>fE` = sidebar; `<leader>fe` stays the float (default).
  Rejected: a config switch in snacks.lua, a runtime style toggle.
- Side: **right**, as in §1 (the opencode panel is on the right too; side by side is accepted).
- Sidebar preview: **on by default** (shown in the editor window, snacks' `preview = "main"`), `P` toggles.

Plan revised: proposal (sidebar bullet), spec (new requirement "Sidebar alternative"), design (decision
7, non-goal wording), tasks (§4 build, §5 human check).

## Next

- §4, task 4.1: add the `<leader>fE` key in `lua/plugins/snacks.lua` with call-level opts (design
  decision 7).
