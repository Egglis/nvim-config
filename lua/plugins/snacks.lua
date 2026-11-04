local position = "bottom"

local function move_terminals(to)
  position = to
  local vertical = to == "left" or to == "right"
  local current = vim.api.nvim_get_current_win()
  local terminals = Snacks.terminal.list()
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

return {
  "folke/snacks.nvim",
  init = function()
    -- Load snacks on the first vim.ui.select; its picker setup then replaces this stub.
    vim.ui.select = function(...)
      return require("snacks").picker.select(...)
    end
  end,
  keys = {
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
    terminal = {},
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
