return {
	'folke/tokyonight.nvim',
	priority = 1000,
	lazy = false,
	config = function()
		require("tokyonight").setup({
			style = 'night',

			on_highlights = function(hl, colors)
				hl.LineNrAbove = {
					fg = colors.blue, -- Use the theme's yellow color
					bold = true,
				}

				hl.LineNrBelow = {
					fg = colors.blue, -- Use the theme's yellow color
					bold = true,
				}
			end,
		})
		require('tokyonight').load()
	end,
}
