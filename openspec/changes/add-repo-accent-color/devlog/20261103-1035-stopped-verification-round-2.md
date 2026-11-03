# Stopped: verification round 2 — more colour

<!-- Section: 2 · Tasks: 2.1–2.4 · Base: c2853a5 -->

Round 1 answer: "It works, but i need more color, it is difficult to see quickly on the fly".
Asked where; user chose **statusline tint + top bar** (over full-colour statusline / window borders).
Scope updated in spec (split into "Tinted statusline" + "Top bar" requirements — one long requirement
tripped `--strict`), design decision 8, task 2.3 (new) / 2.4 (verification).

Built: `blend()`; tint = accent 45% over `#16161e` on lualine sections b/c of every mode via a deepcopy
of `lualine.themes.auto`; lualine `config` → `repo_accent.attach_lualine(opts)` which owns
`lualine.setup()` and re-runs it on repo change; tabline `%#RepoAccentBar#%=<name>%=`, `showtabline=2`,
re-applied on `ColorScheme`; outside a repo `showtabline=1`, `tabline=""`, plain theme.

Headless UI checks (temp dir, not committed): `REPO_ACCENT_UI_EXIT:0` (14 checks: tint bg `#605180` for
accent `#bb9af7`, block first, tabline, Normal bg unchanged, ColorScheme survival, leave/re-enter repo).
Module checks still `REPO_ACCENT_TEST_EXIT:0`.
Gates: `BUILD_EXIT:0` `FORMAT_EXIT:0` `VALIDATE_EXIT:0` `GATES_EXIT:0`

## Next

- Waiting on user's look check (recipe in chat). On pass: tick 2.1–2.4, section-done note, commit
  `feat(add-repo-accent-color): tinted statusline, top bar and docs (§2)` incl. readme.md + AGENTS.md,
  then whole-change review.
- Tuning knobs if asked: `TINT_ALPHA` (0.45) in `repo_accent.lua`; top bar could be made a tint too.
- Headless note: lualine re-renders slightly after `:cd`; the UI test waits 300 ms + `refresh()`.
