local lsp_config = require('lsp_config')

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- LSP Installer and utilities
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'folke/neodev.nvim', -- Enhances Neovim Lua LSP config
    },
    -- Setup LSP servers and handlers
    config = function()
      -- Setup Neodev for better Lua LSP configuration
      require('neodev').setup()

      -- Setup Mason, then Mason-LSPConfig
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(lsp_config.servers),
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup {
              capabilities = lsp_config.capabilities,
              on_attach = lsp_config.on_attach,
              settings = lsp_config.servers[server_name],
              filetypes = (lsp_config.servers[server_name] or {}).filetypes,
            }
          end,
        },
      }
    end,
  },
}