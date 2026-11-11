-- Standalone-only mappings. Mappings shared with VSCode live in keymaps/shared.lua.

-- The current .csproj, else the nearest one above the current file (or cwd).
local function find_csproj()
  local file = vim.api.nvim_buf_get_name(0)
  if file:match("%.csproj$") then
    return file
  end
  local dir = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  return vim.fs.find(function(name)
    return name:match("%.csproj$") ~= nil
  end, { upward = true, path = dir, limit = 1 })[1]
end

-- Opens the project's user secrets file (like VSCode's ".NET Core User Secrets" extension).
local function open_user_secrets()
  local csproj = find_csproj()
  if not csproj then
    return vim.notify("No .csproj found", vim.log.levels.WARN, { title = "User secrets" })
  end
  local id = table.concat(vim.fn.readfile(csproj), "\n"):match("<UserSecretsId>%s*(.-)%s*</UserSecretsId>")
  if not id or id == "" then
    return vim.notify(
      "No <UserSecretsId> in " .. vim.fs.basename(csproj) .. " (run `dotnet user-secrets init`)",
      vim.log.levels.WARN,
      { title = "User secrets" }
    )
  end
  local root = vim.fn.has("win32") == 1 and vim.fs.joinpath(vim.env.APPDATA, "Microsoft", "UserSecrets")
    or vim.fs.joinpath(vim.env.HOME, ".microsoft", "usersecrets")
  local dir = vim.fs.joinpath(root, id)
  local path = vim.fs.joinpath(dir, "secrets.json")
  vim.fn.mkdir(dir, "p")
  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({ "{", "}" }, path)
  end
  vim.cmd.edit(vim.fn.fnameescape(path))
end

return function()
  vim.keymap.set("n", "<M-q>", "<cmd>b#<CR>", { desc = "Go back to the last buffer" })
  vim.keymap.set("n", "<leader>ns", open_user_secrets, { desc = ".[N]ET user [S]ecrets" })
  vim.keymap.set("n", "<leader>qs", function()
    require("config.session").restore()
  end, { desc = "Restore this project's [S]ession" })
end
