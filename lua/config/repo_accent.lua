-- Per-repo accent color for the statusline and the terminal title (standalone Neovim only).
local M = {}

-- tokyonight night accents; hard-coded so this module never requires the plugin.
M.palette = {
  "#7aa2f7", -- blue
  "#7dcfff", -- cyan
  "#9ece6a", -- green
  "#ff007c", -- magenta
  "#ff9e64", -- orange
  "#bb9af7", -- purple
  "#f7768e", -- red
  "#1abc9c", -- teal
  "#e0af68", -- yellow
}

local DARK_FG = "#1a1b26"
local LIGHT_FG = "#c0caf5"

M.state = { root = nil, name = nil, accent = nil, fg = nil }

-- Walks `text` outside strings: `on_char(text, i, c)` returns the text to emit and the last index used.
local function walk(text, on_char)
  local out, i, n = {}, 1, #text
  local in_string = false
  while i <= n do
    local c = text:sub(i, i)
    if in_string then
      out[#out + 1] = c
      if c == "\\" then
        out[#out + 1] = text:sub(i + 1, i + 1)
        i = i + 1
      elseif c == '"' then
        in_string = false
      end
    elseif c == '"' then
      in_string = true
      out[#out + 1] = c
    else
      local emit, last = on_char(text, i, c)
      out[#out + 1] = emit
      i = last
    end
    i = i + 1
  end
  return table.concat(out)
end

local function strip_comments(text, i, c)
  local nxt = text:sub(i + 1, i + 1)
  if c == "/" and nxt == "/" then
    return "", (text:find("\n", i, true) or #text + 1) - 1
  elseif c == "/" and nxt == "*" then
    local close = text:find("*/", i + 2, true)
    return " ", close and close + 1 or #text
  end
  return c, i
end

local function strip_trailing_commas(text, i, c)
  if c == "," then
    local next_char = text:match("^%s*(.)", i + 1)
    if next_char == "}" or next_char == "]" then
      return "", i
    end
  end
  return c, i
end

-- Strips // and /* */ comments and trailing commas outside strings, then decodes. nil on failure.
function M.parse_jsonc(text)
  local clean = walk(walk(text, strip_comments), strip_trailing_commas)
  local ok, decoded = pcall(vim.json.decode, clean)
  if ok and type(decoded) == "table" then
    return decoded
  end
  return nil
end

local function hex6(value)
  if type(value) ~= "string" then
    return nil
  end
  local rgb = value:match("^#(%x%x%x%x%x%x)$") or value:match("^#(%x%x%x%x%x%x)%x%x$")
  return rgb and ("#" .. rgb:lower()) or nil
end

-- Accent from `<root>/.vscode/settings.json`, or nil.
function M.vscode_color(root)
  local path = vim.fs.joinpath(root, ".vscode", "settings.json")
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or #lines == 0 then
    return nil
  end
  local settings = M.parse_jsonc(table.concat(lines, "\n"))
  local custom = settings and settings["workbench.colorCustomizations"]
  if type(custom) ~= "table" then
    return nil
  end
  return hex6(custom["statusBar.background"]) or hex6(custom["titleBar.activeBackground"])
end

function M.hashed_color(name)
  local index = tonumber(vim.fn.sha256(name):sub(1, 8), 16) % #M.palette
  return M.palette[index + 1]
end

function M.fg_for(accent)
  local r, g, b = accent:match("^#(%x%x)(%x%x)(%x%x)$")
  local luminance = (0.299 * tonumber(r, 16) + 0.587 * tonumber(g, 16) + 0.114 * tonumber(b, 16)) / 255
  return luminance > 0.5 and DARK_FG or LIGHT_FG
end

-- Computes { root, name, accent, fg } for a directory; root/accent are nil outside a git repo.
function M.resolve(dir)
  local root = vim.fs.root(dir, ".git")
  if not root then
    return { name = vim.fs.basename(vim.fs.normalize(dir)) }
  end
  local name = vim.fs.basename(root)
  local accent = M.vscode_color(root) or M.hashed_color(name)
  return { root = root, name = name, accent = accent, fg = M.fg_for(accent) }
end

function M.update()
  M.state = M.resolve(vim.fn.getcwd())
  vim.o.title = true
  vim.o.titlestring = (M.state.name or "nvim"):gsub("%%", "%%%%")
  if package.loaded.lualine then
    require("lualine").refresh()
  end
end

-- lualine component: repo name on the accent color, hidden outside a repo.
function M.component()
  return {
    function()
      return M.state.name or ""
    end,
    cond = function()
      return M.state.accent ~= nil
    end,
    color = function()
      return { fg = M.state.fg, bg = M.state.accent, gui = "bold" }
    end,
  }
end

function M.setup()
  M.update()
  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    group = vim.api.nvim_create_augroup("repo_accent", { clear = true }),
    callback = M.update,
  })
end

return M
