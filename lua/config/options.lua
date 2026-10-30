local opt = vim.opt

-- Leader (must be set before any mapping)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Timing
opt.updatetime = 250
opt.timeoutlen = 300

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Display
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8

-- Standalone Neovim only
if not vim.g.vscode then
  opt.clipboard = "unnamedplus"
  opt.undofile = true
  opt.signcolumn = "yes"
  opt.cursorline = true
  opt.splitright = true
  opt.splitbelow = true
end
