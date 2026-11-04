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
  keys = {
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
  },
}
