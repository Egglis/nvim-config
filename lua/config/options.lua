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

  -- Cheaper cursor moves: bracket matching gives up after 20 ms, regex highlighting stops at column 300.
  -- matchparen reads these when it runs, after init.lua.
  vim.g.matchparen_timeout = 20
  vim.g.matchparen_insert_timeout = 20
  opt.synmaxcol = 300

  -- MSBuild files (.csproj and Directory.Build.* are already xml).
  vim.filetype.add({ extension = { props = "xml", targets = "xml" } })

  -- PowerShell as the shell (:h shell-powershell). -NoProfile keeps :! and system() fast; an
  -- interactive :terminal runs bare 'shell' (no shellcmdflag), so it still loads the profile.
  opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  opt.shellcmdflag = "-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command "
    .. "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();"
    .. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    .. "$PSStyle.OutputRendering='plaintext';"
    .. "Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
  opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  opt.shellquote = ""
  opt.shellxquote = ""
end
