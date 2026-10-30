local M = {}

function M.on_attach(_, bufnr)
  local telescope = require("telescope.builtin")

  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", function()
    vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
  end, "[C]ode [A]ction")

  nmap("<leader>gd", telescope.lsp_definitions, "[G]oto [D]efinition")
  nmap("<leader>gr", telescope.lsp_references, "[G]oto [R]eferences")
  nmap("<leader>gi", telescope.lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>td", telescope.lsp_type_definitions, "Type [D]efinition")
  nmap("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

return M
