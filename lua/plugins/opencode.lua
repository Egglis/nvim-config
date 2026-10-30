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
    "nvim-telescope/telescope.nvim",
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
    preferred_picker = "telescope",
    lock_session_to_directory = true,
    ui = {
      position = "right",
      window_width = 0.40,
    },
  },
}
