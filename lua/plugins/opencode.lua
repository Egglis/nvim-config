return {
  "sudo-tee/opencode.nvim",
  cmd = "Opencode",
  keys = {
    { "<leader>og", desc = "Toggle Opencode window" },
    { "<leader>oi", desc = "Open input window" },
    { "<leader>oI", desc = "Open input (new session)" },
  },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "folke/snacks.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "opencode_output" },
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
    },
  },
  opts = {
    preferred_picker = "snacks",
    lock_session_to_directory = true,
    ui = {
      position = "right",
      window_width = 0.40,
    },
    keymap = {
      input_window = {
        -- <M-m> is swallowed by the Windows terminal as a window-close key; use <leader>om instead.
        -- Normal mode only: an insert-mode <leader> mapping makes every typed space wait for timeoutlen.
        ["<M-m>"] = false,
        ["<leader>om"] = { "switch_mode", mode = "n" },
      },
    },
  },
  config = function(_, opts)
    require("opencode").setup(opts)

    -- The plugin remembers a model per agent mode; keep the current model when switching modes instead.
    local agent_model = require("opencode.services.agent_model")
    local Promise = require("opencode.promise")
    local state = require("opencode.state")
    local switch_to_mode = agent_model.switch_to_mode
    agent_model.switch_to_mode = Promise.async(function(mode)
      local model = state.current_model
      local ok = switch_to_mode(mode):await()
      if ok and model then
        state.model.set_model(model)
      end
      return ok
    end)
  end,
}
