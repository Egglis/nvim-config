-- One session per project: saved on exit (incl. :qa!), restored on demand (start screen, <leader>qs, `nvc`).
local M = {}

local dir = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions")

-- Project = the repo root the accent uses (git, else .vscode), otherwise Neovim's cwd.
function M.file()
  local cwd = vim.fn.getcwd(-1, -1)
  local project = require("config.repo_accent").find_root(cwd) or cwd
  local name = vim.fs.normalize(project):lower():gsub("[\\/:]", "%%")
  return vim.fs.joinpath(dir, name .. ".vim")
end

function M.exists()
  return vim.fn.filereadable(M.file()) == 1
end

local function has_files()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
      return true
    end
  end
  return false
end

function M.save()
  -- Quitting from the start screen (no files open) keeps the previous session.
  if not has_files() then
    return
  end
  -- Terminals, the explorer sidebar, the OpenCode panel etc. aren't files; drop their windows first.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local float = vim.api.nvim_win_get_config(win).relative ~= ""
    if
      (float or vim.bo[buf].buftype ~= "") and #vim.api.nvim_tabpage_list_wins(vim.api.nvim_win_get_tabpage(win)) > 1
    then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  vim.fn.mkdir(dir, "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(M.file()))
end

function M.restore()
  local file = M.file()
  if vim.fn.filereadable(file) == 0 then
    return vim.notify("No saved session for this project", vim.log.levels.WARN, { title = "Session" })
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].modified and vim.bo[buf].buftype == "" then
      return vim.notify("Save or discard your changes first", vim.log.levels.WARN, { title = "Session" })
    end
  end
  vim.cmd("silent! source " .. vim.fn.fnameescape(file))
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "snacks_dashboard" then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

function M.setup()
  vim.opt.sessionoptions = { "buffers", "curdir", "folds", "tabpages", "winsize" }
  vim.api.nvim_create_user_command("SessionRestore", M.restore, { desc = "Restore this project's session" })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("session", { clear = true }),
    callback = function()
      local ok, err = pcall(M.save)
      if not ok then
        vim.notify("Session not saved: " .. err, vim.log.levels.ERROR)
      end
    end,
  })
end

return M
