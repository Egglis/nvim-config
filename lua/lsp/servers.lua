-- Language servers to install and enable. Each entry: { settings = ..., filetypes = ... }.
return {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = { disable = { "missing-fields" } },
      },
    },
  },
  -- C#. Mason's package installs the server as `roslyn-language-server`, not lspconfig's default binary name.
  roslyn_ls = {
    cmd = {
      "roslyn-language-server",
      "--logLevel",
      "Information",
      "--extensionLogDirectory",
      vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls/logs"),
      "--stdio",
    },
  },
}
