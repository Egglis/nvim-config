# Decision: cmd edit commands for lazygit, not pwsh

<!-- Section: 1 · Tasks: 1.2 · Base: 16a7db7 -->

Design decision 3 planned a `pwsh -NoProfile -Command …` edit line with `$env:NVIM`, on the belief
that lazygit escapes `%`. lazygit 0.66.1 (installed by winget) runs edits as a raw
`cmd /s /c "<command>"` with no escaping (`pkg/commands/oscommands/cmd_obj_builder.go`,
`newWindowsShell`), so `%NVIM%` expands in plain cmd.

Tested against a real `nvim --headless --listen` server, by running the exact command line lazygit builds:
- cmd form `nvim --server %NVIM% --remote-send "<C-\><C-n>" && nvim --server %NVIM% --remote "<file>" && nvim --server %NVIM% --remote-send ":3<CR>"`
  → exit 0, server showed `…\a b.txt line 3` (a path with a space works).
- pwsh form → `< was unexpected at this time.`: cmd still parses the `<` inside `'…'`, because single
  quotes mean nothing to cmd.

lazygit passes absolute, quoted paths (`files_helper.go` uses `filepath.Abs`), and Neovim's `--remote`
does not expand paths on the client side, so absolute paths are needed, and lazygit provides them.
Generated `lazygit-theme.yml` was fed to lazygit: it starts with it, but exits at once on a broken
YAML used as a control.

design.md decision 3 and the 1.2 verify text were updated to the cmd form.

## Next

- Finish §1 (docs, gates, commit), then §2.1.
