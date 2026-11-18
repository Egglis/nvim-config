return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "folke/snacks.nvim", -- kind icons
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
  },
  config = function()
    local cmp = require("cmp")
    -- Same kind icons as the snacks LSP symbol pickers (no icon plugin).
    local kind_icons = require("snacks.picker.config").get().icons.kinds

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      window = {
        completion = cmp.config.window.bordered({ border = "rounded" }),
        documentation = cmp.config.window.bordered({ border = "rounded" }),
      },
      -- Icon, then the text, then the kind name dimmed on the right: ` GetValue  Method`.
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          local kind = item.kind or ""
          item.menu = kind
          item.kind = kind_icons[kind] or "  "
          return item
        end,
      },
      -- The selected item's rest, greyed out after the cursor; <CR> takes it.
      experimental = { ghost_text = true },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.snippet.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
      },
    })
  end,
}
