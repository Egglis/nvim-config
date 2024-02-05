return {
	"tpope/vim-fugitive",
	config = function(_,opts)
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
	end,
}
