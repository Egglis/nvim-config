# Decision: float with the preview on, instead of the right sidebar

<!-- Base: 328be0b -->

After §1 the user asked for the preview on by default and "a float version similar to the git". Answers:

- What floats: **the whole explorer** as a centred float with a preview pane, like the git pickers
  (`<leader>gs`, `<leader>gl`). It **replaces** the right sidebar (not a second key, not a floating
  preview next to the sidebar).
- Preview on by default: in every version (only the float now). `P` still toggles it.
- Opening a file: **closes the float**, like the other pickers (recommended option, chosen). Rejected:
  keeping it open, since the float would cover the file just opened.

Also decided (design decision 3, revised): `auto_close = true`, so leaving the float closes it like
every other picker; layout uses the same rule as the pickers' default (`default` at 120+ columns, else
`vertical`).

Plan revised: proposal, spec (toggle → float; "Opening a file keeps the tree" → "closes the tree";
preview on at open, `P` toggles), design (decisions 3 and 6, context, risks), tasks (new §2 "Float with
preview", human check moved to §3). `VALIDATE_EXIT:0`.

The earlier answer to "how do I jump focus to it" (`<C-w>l`) no longer applies; with a float the cursor
is always in it while open.

## Next

- §2, task 2.1: change `opts.picker.sources.explorer` in `lua/plugins/snacks.lua` to the float layout
  with `preview = true`, `jump = { close = true }`, `auto_close = true`; keep the two key overrides.
