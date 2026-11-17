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
        lualine_x = { "searchcount", "encoding", "fileformat", "filetype" },
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
