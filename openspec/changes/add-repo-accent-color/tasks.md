## 1. Repo accent module

- [x] 1.1 Create `lua/config/repo_accent.lua` with repo detection (`vim.fs.root(cwd, ".git")`), the JSONC
      stripper + settings reader (`statusBar.background` → `titleBar.activeBackground`), the hashed
      tokyonight palette fallback, and luminance-based foreground choice
- [x] 1.2 Add `setup()`: autocmds on `VimEnter`/`DirChanged` that recompute the state, set `title` and
      `titlestring`, and refresh lualine if loaded; call it from the standalone branch of `init.lua`
- [x] 1.3 Check the helpers headless (`nvim --headless -c "lua ..."`): JSONC with comments/trailing
      commas, precedence, malformed file, stable hash, not-in-repo

## 2. Statusline and docs

- [ ] 2.1 Add the repo component as the first item of `lualine_a` in `lua/plugins/lualine.lua`
      (hidden outside a repo), keeping `mode` after it
- [ ] 2.2 Document the repo accent in `AGENTS.md` (directory tree, behaviour, how to pin a colour) and
      tick the first TODO in `readme.md`
- [ ] 2.3 Human verification: statusline block and terminal tab title in two different repos
