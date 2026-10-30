# Fix: Space lagged in the OpenCode input window

<!-- Section: 4 · Tasks: n/a · Base: 0e00e41 -->

- User reported typing Space in the input window paused, waiting for a `<leader>` sequence.
- Cause: the `<leader>om` (switch_mode) override from the earlier `<M-m>` decision was mapped in insert mode
  too; leader is Space, so every Space waited `timeoutlen`.
- Fix: `["<leader>om"] = { "switch_mode", mode = "n" }`. Switch mode via `<Esc><Space>om`.
- New rule from the user: personal project, commit straight to `master` and push; no change branches or PRs.
  Recorded in `AGENTS.md` (`### Git`). `change/add-opencode-panel` merged into `master` and deleted.
- `BUILD_EXIT:0`. `FORMAT_EXIT:1` only because `stylua` is not installed on this machine.

## Next

- Wait for the user's §4.1 result (panel toggles, `<leader>oI` new session, `:checkhealth opencode`, and Space
  types without delay). If OK, tick 4.1, then whole-change review (`git diff 20cb9eb..HEAD`), offer the
  independent review, then offer archive.
