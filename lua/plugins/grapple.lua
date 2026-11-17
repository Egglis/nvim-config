local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Marks" })
end

-- Marks the current file, or unmarks it if it's already marked, and says which.
local function toggle_mark()
  local path = vim.api.nvim_buf_get_name(0)
  if vim.bo.buftype ~= "" or path == "" then
    return notify("Only files can be marked")
  end
  local grapple = require("grapple")
  local name = vim.fs.basename(path)
  local was_marked = grapple.exists()
  if grapple.toggle() then
    return -- grapple already reported the error
  end
  if was_marked then
    return notify("Unmarked " .. name)
  end
  for i, tag in ipairs(grapple.tags() or {}) do
    if vim.fs.normalize(tag.path) == vim.fs.normalize(path) then
      return notify(("Marked %d: %s"):format(i, name))
    end
  end
end

local function select_mark(index)
  local grapple = require("grapple")
  if not grapple.find({ index = index }) then
    return notify("No mark " .. index)
  end
  grapple.select({ index = index })
end

local keys = {
  { "<leader>ha", toggle_mark, desc = "[H]arpoon: [A]dd/remove file mark" },
  {
    "<leader>hh",
    function()
      -- Not the Snacks global: snacks may not be loaded yet.
      require("snacks").picker.pick("grapple")
    end,
    desc = "[H]arpoon: search marks",
  },
  {
    "<leader>he",
    function()
      require("grapple").toggle_tags()
    end,
    desc = "[H]arpoon: [E]dit mark list",
  },
}
for i = 1, 9 do
  keys[#keys + 1] = {
    "<leader>h" .. i,
    function()
      select_mark(i)
    end,
    desc = "[H]arpoon: go to mark " .. i,
  }
end

return {
  "cbochs/grapple.nvim",
  cmd = "Grapple",
  keys = keys,
  opts = {
    -- The git root of the cwd, else the cwd. grapple's own "git" scope is cached until BufEnter, so a
    -- :cd kept the old list; this one is cached until the cwd changes.
    scope = "project",
    scopes = {
      {
        name = "project",
        desc = "Git root of the cwd, else the cwd",
        cache = { event = "DirChanged" },
        resolver = function()
          local cwd = vim.fn.getcwd()
          local root = vim.fs.root(cwd, ".git") or cwd
          return root, root
        end,
      },
    },
    icons = false,
    style = "basename",
    win_opts = { border = "rounded" },
  },
}
