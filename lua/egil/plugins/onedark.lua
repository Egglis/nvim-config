return {
	"navarasu/onedark.nvim",
	priority = 1000,
	opts = {
		style = "darker",
		transparent = true
	},
	config = function(_, opts)
		require("onedark").setup(opts)
		vim.cmd([[colorscheme onedark]])
	end,
}
