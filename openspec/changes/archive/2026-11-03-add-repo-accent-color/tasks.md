## 1. Repo accent module

- [x] 1.1 Create `lua/config/repo_accent.lua` with repo detection (`vim.fs.root(cwd, ".git")`), the JSONC
      stripper + settings reader (`statusBar.background` → `titleBar.activeBackground`), the hashed
      tokyonight palette fallback, and luminance-based foreground choice
- [x] 1.2 Add `setup()`: autocmds on `VimEnter`/`DirChanged` that recompute the state, set `title` and
      `titlestring`, and refresh lualine if loaded; call it from the standalone branch of `init.lua`
- [x] 1.3 Check the helpers headless (`nvim --headless -c "lua ..."`): JSONC with comments/trailing
      commas, precedence, malformed file, stable hash, not-in-repo

## 2. Statusline and docs

- [x] 2.1 Add the repo component as the first item of `lualine_a` in `lua/plugins/lualine.lua`
      (hidden outside a repo), keeping `mode` after it
- [x] 2.2 Document the repo accent in `AGENTS.md` (directory tree, behaviour, how to pin a colour) and
      tick the first TODO in `readme.md`
- [x] 2.3 Tint lualine sections b/c with the blended accent (re-setup on repo change via
      `attach_lualine`) and add the full-width accent top bar (tabline, `showtabline=2`, `ColorScheme`
      re-apply); revert both outside a repo
- [x] 2.4 Human verification: statusline tint, top bar and terminal tab title in two different repos
