# Stopped: human check (4.3)

<!-- Section: 4 · Tasks: 4.1–4.2 done, 4.3 waiting · Base: 697bbba -->

- 4.2: the user's answer, given the numbers in `20261110-1103-stopped-relnum-cursorline.md`: **keep both
  `relativenumber` and `cursorline`**. No TODO, no follow-up.
- 4.3: the human-check recipe was sent to the user (it's below so a cold session can repeat it).

Uncommitted: `readme.md` (headline number), `tasks.md` (4.1–4.2 ticked), the two §4 devlog notes.

Recipe:
1. Close every Neovim. Open a big real C# file in a real project (so Roslyn attaches), hold `j` then `k`
   for a few seconds. Do the same in a big Lua file (e.g. `lua/plugins/snacks.lua`). Smooth?
2. Colours look right in: a `.cs`, a `.csproj`, an `appsettings.json`, a `.ps1`, and a `.py` file.
   (`:lua print(vim.treesitter.highlighter.active[0] ~= nil)` → `true` in each.)
3. Put the cursor on a `(` and a `{` in C#: the matching bracket is highlighted.
4. `:!echo hi` prints `hi`; `<leader>tt` opens the pwsh terminal with your prompt.
5. VSCode with vscode-neovim: it starts with no error, and `<leader>y` (yank to clipboard), `<C-d>`
   (half-page + centre) and `Ø` (into the next quoted string) work.

## Next

- When the user answers: on all-pass, record the answers in a note, tick 4.3, `pwsh ./gates.ps1 gates`,
  write the section-done note, commit `feat(faster-scrolling): measure and check (§4)`, push, then the
  whole-change review (`git diff 014df00..HEAD`).
- On a failure: record what failed and agree a fix as a new section before going on.
