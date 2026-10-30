return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "folke/neodev.nvim",
    },
    config = function()
      local servers = require("lsp.servers")
      local on_attach = require("lsp.keymaps").on_attach
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("neodev").setup()

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = server.settings,
              filetypes = server.filetypes,
            })
          end,
        },
      })
    end,
  },
}
