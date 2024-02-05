local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.setup()

require("mason").setup({})

require("mason-lspconfig").setup({
	ensure_installed = {},
	handlers = {
		lsp.default_setup,
	}
})

