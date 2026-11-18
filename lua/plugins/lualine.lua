local function hl_color(name, attr)
  local value = vim.api.nvim_get_hl(0, { name = name, link = false })[attr]
  return value and string.format("#%06x", value)
end

-- `REC @q` while a macro is recording; Neovim's own "recording @q" is gone with cmdheight=0.
local recording = {
  function()
    return "REC @" .. vim.fn.reg_recording()
  end,
  cond = function()
    return vim.fn.reg_recording() ~= ""
  end,
  color = function()
    return { fg = hl_color("Normal", "bg") or "#000000", bg = hl_color("DiagnosticError", "fg"), gui = "bold" }
  end,
}

-- Size of the visual selection: `4 lines`, `12 chars`, or `4x12` for a block.
local selection = {
  function()
    local mode = vim.fn.mode()
    local lines = math.abs(vim.fn.line("v") - vim.fn.line(".")) + 1
    if mode == "\22" then
      return ("%dx%d"):format(lines, math.abs(vim.fn.virtcol("v") - vim.fn.virtcol(".")) + 1)
    elseif mode == "V" or lines > 1 then
      return lines .. " lines"
    end
    return vim.fn.wordcount().visual_chars .. " chars"
  end,
  cond = function()
    return vim.fn.mode():find("^[vV\22]") ~= nil
  end,
}

-- `h3` when the file is grapple mark 3 (the <leader>h3 slot), or the mark's name if it was renamed.
-- Loads grapple with the statusline, so the marks show before the first <leader>h key.
local mark = {
  function()
    local ok, grapple = pcall(require, "grapple")
    local tag = ok and grapple.name_or_index({ buffer = 0 })
    if type(tag) == "number" then
      return "h" .. tag
    end
    return tag or ""
  end,
  cond = function()
    return vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= ""
  end,
}

-- Path from the cwd (the repo root, usually), so same-named files in different folders can be told apart.
local filename = { "filename", path = 1, symbols = { modified = "[+]", readonly = "[RO]" } }

return {
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  opts = function()
    return {
      options = {
        icons_enabled = true,
        theme = "auto", -- replaced by repo_accent's tinted copy of the auto theme
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { require("config.repo_accent").component(), "mode", recording },
        lualine_c = { filename, mark },
        lualine_x = { "searchcount", selection, { "lsp_status", icon = "" }, "filetype" },
      },
      inactive_sections = {
        lualine_c = { filename },
        lualine_x = { "location" },
      },
    }
  end,
  config = function(_, opts)
    require("config.repo_accent").attach_lualine(opts)
    -- lualine only redraws on its timer; show and hide the recording block right away.
    local group = vim.api.nvim_create_augroup("lualine_recording", { clear = true })
    local function refresh()
      require("lualine").refresh({ place = { "statusline" } })
    end
    vim.api.nvim_create_autocmd("RecordingEnter", { group = group, callback = refresh })
    -- reg_recording() is still set during RecordingLeave.
    vim.api.nvim_create_autocmd("RecordingLeave", {
      group = group,
      callback = function()
        vim.schedule(refresh)
      end,
    })
  end,
}
