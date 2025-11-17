local cmp_nvim_lsp = require('cmp_nvim_lsp')
local telescope = require('telescope.builtin')

-- Define LSP server-specific settings
local M = {
  servers = {
    -- Example Language Server: lua_ls
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = { disable = { 'missing-fields' } },
      },
    },
    -- Add more servers here, e.g., 'tsserver', 'rust_analyzer', etc.
  },
}

-- This function runs when an LSP client attaches to a buffer.
M.on_attach = function(_, bufnr)
  -- Helper function to set keymaps for LSP items
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Keymaps for LSP functionality
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', function()
    vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
  end, '[C]ode [A]ction')

  -- Keymaps using Telescope
  nmap('<leader>gd', telescope.lsp_definitions, '[G]oto [D]efinition')
  nmap('<leader>gr', telescope.lsp_references, '[G]oto [R]eferences')
  nmap('<leader>gi', telescope.lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>td', telescope.lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Other useful LSP keymaps
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- User command for formatting
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Function to get LSP capabilities for nvim-cmp
M.capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

return M
