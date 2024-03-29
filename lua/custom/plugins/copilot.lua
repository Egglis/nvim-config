return {
	{ "AndreM222/copilot-lualine" },
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<M-l>",
						accept_word = false,
						accept_line = false,
						next = "<M-n>",
						prev = "<M-p>",
						dismiss = "<C-]>",
					}
				}
			})
		end
	}
}
