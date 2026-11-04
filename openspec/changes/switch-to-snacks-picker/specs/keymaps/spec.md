# Spec Delta

## REMOVED Requirements

### Requirement: Standalone search pickers
**Reason**: Pickers get their own `picker` capability, which keeps these four keys and adds the command palette, more find keys and the closing behaviour.
**Migration**: Same keys in standalone Neovim: `<leader>ff`, `<leader>fa`, `<leader>fb` and `<leader>fh`. See the `picker` spec's "Find pickers" requirement.
