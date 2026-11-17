-- Macro helpers for the <leader>fm picker: list, run and edit the a–z registers.
local M = {}

-- Non-empty registers a–z, keys in readable form (<Esc>, <CR>, <lt>).
function M.list()
  local items = {}
  for byte = string.byte("a"), string.byte("z") do
    local reg = string.char(byte)
    local keys = vim.fn.getreg(reg)
    if keys ~= "" then
      local readable = vim.fn.keytrans(keys)
      items[#items + 1] = {
        text = reg .. ": " .. readable,
        reg = reg,
        label = reg,
        value = readable,
        preview = { text = readable, ft = "text" },
      }
    end
  end
  return items
end

-- Same as typing @{reg}: the `@` isn't remapped, the register's keys are.
function M.run(reg)
  vim.api.nvim_feedkeys("@" .. reg, "n", false)
end

-- Readable keys in a float; :w stores them back into the register, closing without :w keeps it.
function M.edit(reg)
  local name = "macro://" .. reg
  local old = vim.fn.bufnr(name)
  if old ~= -1 then
    vim.api.nvim_buf_delete(old, { force = true })
  end
  local readable = vim.fn.keytrans(vim.fn.getreg(reg))
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, name)
  vim.bo[buf].buftype = "acwrite"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { readable })
  vim.bo[buf].modified = false

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "")
      vim.fn.setreg(reg, vim.keycode(text), "c")
      vim.bo[buf].modified = false
      vim.notify("Saved macro @" .. reg)
    end,
  })

  local width = math.min(math.max(vim.fn.strdisplaywidth(readable) + 4, 50), vim.o.columns - 4)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = 1,
    row = math.floor((vim.o.lines - 3) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
    title = " Macro @" .. reg .. " (:w saves, q closes) ",
    title_pos = "center",
  })
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, "<cmd>close!<CR>", { buffer = buf, desc = "Close the macro editor" })
  end
end

return M
