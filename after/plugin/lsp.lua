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


local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
window = {
completion = cmp.config.window.bordered(),
documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
	['<C-Space>'] = cmp.mapping.confirm(),
	['<C-f>'] = cmp_action.luasnip_jump_forward(),
	['<C-b>'] = cmp_action.luasnip_jump_backward(),
	['<C-u>'] = cmp.mapping.scroll_docs(-4),
	['<C-d>'] = cmp.mapping.scroll_docs(4),
	})
})


  cmp.setup({
    sources = {
      {name = 'nvim_lsp'},
    }
  })


