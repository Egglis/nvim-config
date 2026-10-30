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
}
