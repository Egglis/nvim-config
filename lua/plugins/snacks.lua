local position = "bottom"

local function move_terminals(to)
  position = to
  local vertical = to == "left" or to == "right"
  local current = vim.api.nvim_get_current_win()
  -- Only the shell terminals from <leader>tt (no cmd); lazygit is a snacks terminal too and stays a float.
  local terminals = vim.tbl_filter(function(term)
    return vim.b[term.buf].snacks_terminal.cmd == nil
  end, Snacks.terminal.list())
  table.sort(terminals, function(a, b)
    return vim.b[a.buf].snacks_terminal.id < vim.b[b.buf].snacks_terminal.id
  end)

  local visible, focused = {}, nil
  for _, term in ipairs(terminals) do
    if term:valid() then
      visible[#visible + 1] = term
      if term.win == current then
        focused = term
      end
      term:hide()
    end
    term.opts.position = to
    term.opts.wo.winfixheight = not vertical
    term.opts.wo.winfixwidth = vertical
  end

  for _, term in ipairs(visible) do
    term:show()
  end
  if focused then
    focused:focus()
  elseif vim.api.nvim_win_is_valid(current) then
    vim.api.nvim_set_current_win(current)
  end
  -- show() enters each window, which can queue a startinsert; stay in normal mode.
  vim.cmd.stopinsert()
end

-- snacks' "cmd" action only types the command; run it when it takes no required argument.
local function run_command(picker, item)
  local nargs = item and item.command and item.command.nargs
  if nargs == "0" or nargs == "?" or nargs == "*" then
    picker:close()
    vim.schedule(function()
      vim.cmd(item.cmd)
    end)
  else
    Snacks.picker.actions.cmd(picker, item)
  end
end

-- multi pickers can't dispatch to a string confirm like "cmd", so the palette routes by item kind.
local function palette_confirm(picker, item)
  if item and item.cmd then
    return run_command(picker, item)
  end
  picker:norm(function()
    if item then
      picker:close()
      vim.api.nvim_input(item.item.lhs)
    end
  end)
end

local function toggle_terminal()
  if vim.v.count == 0 and vim.b.snacks_terminal then
    local buf = vim.api.nvim_get_current_buf()
    for _, term in ipairs(Snacks.terminal.list()) do
      if term.buf == buf then
        term:hide()
        return
      end
    end
  end
  Snacks.terminal.focus(nil, { win = { position = position } })
end

-- Global :cd (the repo accent follows on DirChanged), then the file picker: what <leader>fP does.
local function open_project(dir)
  vim.cmd.cd(vim.fn.fnameescape(dir))
  Snacks.picker.files()
end

-- lazygit runs edits through `cmd /s /c "…"` on Windows, where snacks' default "nvim-remote" preset (POSIX
-- shell syntax) fails. These close the lazygit float in the parent Neovim, then open the file there.
local function lazygit_os()
  if vim.fn.has("win32") == 0 then
    return { editPreset = "nvim-remote" }
  end
  local hide = 'nvim --server %NVIM% --remote-send "<C-\\><C-n><cmd>close<CR>"'
  local open = hide .. " && nvim --server %NVIM% --remote {{filename}}"
  return {
    editPreset = "",
    edit = open,
    editAtLine = open .. ' && nvim --server %NVIM% --remote-send ":{{line}}<CR>"',
    editAtLineAndWait = "nvim +{{line}} {{filename}}",
    openDirInEditor = hide .. " && nvim --server %NVIM% --remote {{dir}}",
    editInTerminal = false,
  }
end

local function start_header()
  local repo = require("config.repo_accent").state
  if not repo.accent then
    return { header = "Neovim", padding = 2 }
  end
  vim.api.nvim_set_hl(0, "StartScreenRepo", { fg = repo.accent, bold = true })
  return { align = "center", text = { { repo.name, hl = "StartScreenRepo" } }, padding = 2 }
end

local start_keys = {
  {
    icon = " ",
    key = "f",
    desc = "Find file",
    action = function()
      Snacks.picker.files()
    end,
  },
  {
    icon = " ",
    key = "g",
    desc = "Grep",
    action = function()
      Snacks.picker.grep()
    end,
  },
  {
    icon = " ",
    key = "r",
    desc = "Recent files",
    action = function()
      Snacks.picker.recent()
    end,
  },
  {
    icon = " ",
    key = "p",
    desc = "Projects",
    action = function()
      Snacks.picker.projects()
    end,
  },
  { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
  {
    icon = " ",
    key = "c",
    desc = "Config",
    action = function()
      open_project(vim.fn.stdpath("config"))
    end,
  },
  { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
  { icon = " ", key = "q", desc = "Quit", action = ":qa" },
}

return {
  "folke/snacks.nvim",
  -- Plain `nvim` loads snacks at startup to draw the start screen; with a file or folder it stays lazy.
  lazy = vim.fn.argc(-1) > 0,
  init = function()
    -- Load snacks on the first vim.ui.select; its picker setup then replaces this stub.
    vim.ui.select = function(...)
      return require("snacks").picker.select(...)
    end
  end,
  keys = {
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "[B]uffer [D]elete (keep window)",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "[B]uffer delete [O]thers",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "[F]ind [F]iles",
    },
    {
      "<leader>fa",
      function()
        Snacks.picker.grep()
      end,
      desc = "[F]ind [A]ll (live grep)",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "[F]ind [B]uffers",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "[F]ind [H]elp",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "[F]ind [R]ecent files",
    },
    {
      "<leader>fw",
      function()
        Snacks.picker.grep_word()
      end,
      mode = { "n", "x" },
      desc = "[F]ind [W]ord (or selection)",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "[F]ind [D]iagnostics",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_status()
      end,
      desc = "[F]ind [G]it changes",
    },
    {
      "<leader>fR",
      function()
        Snacks.picker.resume()
      end,
      desc = "[F]ind [R]esume last picker",
    },
    {
      "<leader>fP",
      function()
        Snacks.picker.projects()
      end,
      desc = "[F]ind [P]rojects",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.pick({
          title = "Command Palette",
          multi = { { source = "keymaps", modes = { "n" } }, "commands" },
          confirm = palette_confirm,
        })
      end,
      desc = "[F]ind in command [P]alette",
    },
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "[F]ind [K]eymaps",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.commands({ confirm = run_command })
      end,
      desc = "[F]ind [C]ommands",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "[G]it: lazy[G]it",
    },
    { "<leader>tt", toggle_terminal, desc = "[T]erminal [T]oggle" },
    { "<C-t>", toggle_terminal, mode = { "n", "t" }, desc = "[T]erminal toggle" },
    {
      "<leader>tr",
      function()
        move_terminals("right")
      end,
      desc = "[T]erminal to the [R]ight",
    },
    {
      "<leader>tb",
      function()
        move_terminals("bottom")
      end,
      desc = "[T]erminal to the [B]ottom",
    },
  },
  opts = {
    -- Start screen on a plain `nvim`; snacks skips it by itself when Neovim gets a file or folder.
    dashboard = {
      sections = {
        start_header,
        { gap = 1, padding = 2, start_keys },
        {
          title = "Recent files",
          icon = " ",
          indent = 2,
          padding = 1,
          -- Built at render time: the repo root comes from repo_accent; nil outside a repo = global.
          function()
            local root = require("config.repo_accent").state.root
            return {
              section = "recent_files",
              limit = 5,
              cwd = root,
              -- `nvim .` leaves the folder itself in v:oldfiles.
              filter = function(file)
                return vim.fn.isdirectory(file) == 0
              end,
            }
          end,
        },
        {
          title = "Projects",
          icon = " ",
          indent = 2,
          padding = 1,
          { section = "projects", limit = 10, action = open_project },
        },
        { section = "startup" },
      },
    },
    terminal = {},
    lazygit = { config = { os = lazygit_os() } },
    picker = {
      -- Ctrl+c and q close a picker; <Esc> only leaves insert mode.
      win = {
        input = {
          keys = {
            ["<C-c>"] = { "cancel", mode = { "i", "n" } },
            ["<Esc>"] = false,
          },
        },
        list = {
          keys = {
            ["<C-c>"] = "cancel",
            ["<Esc>"] = false,
          },
        },
        preview = {
          keys = {
            ["<C-c>"] = "cancel",
            ["<Esc>"] = false,
          },
        },
      },
    },
  },
}
