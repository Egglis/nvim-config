-- lua/plugins/cmp.lua

return {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
  
    },
    config = function()
      local cmp = require('cmp')
  
      cmp.setup {
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          -- REMOVED: <Tab> and <S-Tab> mappings relying on luasnip.
          -- We just keep the default behavior here:
          ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                  cmp.select_next_item()
              else
                  fallback()
              end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                  cmp.select_prev_item()
              else
                  fallback()
              end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
        },
      }
    end,
  }
