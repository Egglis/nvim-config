# Stopped: measured; asking about relativenumber/cursorline (4.2)

<!-- Section: 4 · Tasks: 4.1 done, 4.2 waiting · Base: 697bbba -->

4.1: `measure.ps1` (same script, files and settings as the baseline note `20261110-1003-baseline-0-11.md`)
run twice on Neovim 0.12.6 with §1–§3 in place.

Run 1:
```
cs   (defaults)          0.34 ms/step  hl=ts    lsp=
cs   highlighting off    0.32 ms/step  hl=none  lsp=
cs   set norelativenumber  0.30 ms/step  hl=ts    lsp=
cs   set nocursorline    0.31 ms/step  hl=ts    lsp=
cs   NoMatchParen        0.20 ms/step  hl=ts    lsp=
lua  (defaults)          0.45 ms/step  hl=ts    lsp=lua_ls
lua  highlighting off    0.41 ms/step  hl=none  lsp=lua_ls
lua  set norelativenumber  0.41 ms/step  hl=ts    lsp=lua_ls
lua  set nocursorline    0.46 ms/step  hl=ts    lsp=lua_ls
lua  NoMatchParen        0.27 ms/step  hl=ts    lsp=lua_ls
```
Run 2:
```
cs   (defaults)          0.34 ms/step  hl=ts    lsp=
cs   highlighting off    0.33 ms/step  hl=none  lsp=
cs   set norelativenumber  0.33 ms/step  hl=ts    lsp=
cs   set nocursorline    0.34 ms/step  hl=ts    lsp=
cs   NoMatchParen        0.20 ms/step  hl=ts    lsp=
lua  (defaults)          0.33 ms/step  hl=ts    lsp=lua_ls
lua  highlighting off    0.32 ms/step  hl=none  lsp=lua_ls
lua  set norelativenumber  0.40 ms/step  hl=ts    lsp=lua_ls
lua  set nocursorline    0.31 ms/step  hl=ts    lsp=lua_ls
lua  NoMatchParen        0.21 ms/step  hl=ts    lsp=lua_ls
```

Before/after (ms per `j` step, run 1 / run 2):

| Setup | C# before (0.11, regex) | C# after (0.12, ts) | Lua before | Lua after |
|---|---|---|---|---|
| config defaults | 2.13 / 1.46 | **0.34 / 0.34** | 0.47 / 0.54 | 0.45 / 0.33 |
| highlighting off | 0.72 / 0.44 | 0.32 / 0.33 | 0.32 / 0.44 | 0.41 / 0.32 |
| `norelativenumber` | 1.82 / 1.41 | 0.30 / 0.33 | 0.31 / 0.43 | 0.41 / 0.40 |
| `nocursorline` | 0.91 / 0.68 | 0.31 / 0.34 | 0.43 / 0.43 | 0.46 / 0.31 |
| `NoMatchParen` | 1.42 / 1.35 | 0.20 / 0.20 | 0.19 / 0.28 | 0.27 / 0.21 |

Reading it: C# defaults are 4–6× faster and now as cheap as the Lua file. Tree-sitter highlighting
costs almost nothing over "highlighting off" (0.34 vs 0.33). `relativenumber` and `cursorline` no longer
make a measurable difference (within noise, ±0.05). The remaining biggest part is matchparen
(~0.14 ms/step), which is already capped at 20 ms. Roslyn didn't attach (no `.csproj` next to `Big.cs`),
as in the baseline. The readme TODO line now has the headline number (~1.5–2.1 → 0.34 ms).

Uncommitted: `readme.md` (number), `tasks.md` (4.1 ticked), this note. §4 is committed once, after 4.3.

Question to the user (4.2, design decision 8): with these numbers, keep `relativenumber` and
`cursorline` as they are, or change either one (in a follow-up, not this change)?

## Next

- When the user answers: record the answer in a devlog note, tick 4.2. If they want a change, it goes
  into a readme TODO or a new change, not this one, unless they explicitly agree to a new section.
- Then 4.3 is a stop for a human check: give the recipe (j/k in a big real C# and Lua file; colours
  for C#, `.csproj`, `appsettings.json`, `.ps1`, `.py`; bracket highlight on `(`/`{`; `:!` and the
  terminal; VSCode with vscode-neovim starts and `<leader>y`, `<C-d>`, `Ø` work).
- After 4.3: `GATES_EXIT:0`, section-done note, commit `feat(faster-scrolling): measure and check (§4)`,
  then the whole-change review (first-section base `014df00`).
