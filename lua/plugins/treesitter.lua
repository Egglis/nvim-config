-- Tree-sitter highlighting for languages Neovim ships no parser for. The `main` branch needs Neovim 0.12+,
-- the tree-sitter CLI and a C compiler (see docs/dependencies.md), and doesn't support lazy-loading.
local languages = { "c_sharp", "xml", "json", "powershell", "python" }
local filetypes = { "cs", "xml", "json", "jsonc", "ps1", "python" }

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    -- The json grammar parses comments too, so jsonc needs no parser of its own.
    vim.treesitter.language.register("json", "jsonc")

    vim.schedule(function()
      if vim.fn.executable("tree-sitter") == 0 then
        return
      end
      local installed = {}
      for _, lang in ipairs(ts.get_installed()) do
        installed[lang] = true
      end
      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, languages)
      if #missing > 0 then
        ts.install(missing)
      end
    end)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      pattern = filetypes,
      desc = "Start tree-sitter highlighting; regex syntax stays if the parser is missing",
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
