<# Powershell Profile #>
<# File is ran on startup #>

<# Theme #>
oh-my-posh --init --shell pwsh --config ~/AppData/Local/Programs/oh-my-posh/themes/ys.omp.json | Invoke-Expression

<# Windows Powershell Aliases  #>
Function goto-nvimconfig {Set-Location -Path ~/AppData/Local/nvim}
Set-Alias -Name nconfig -Value goto-nvimconfig

Function saveto-git-repo {cp ~/Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 ~/AppData/Local/nvim/powershell}
Set-Alias -Name sprofile -Value saveto-git-repo

Function goto-desktop {Set-Location -Path ~/Desktop}
Set-Alias -Name desk -Value goto-desktop

Function goto-documents {Set-Location -Path ~/Documents}
Set-Alias -Name doc -Value goto-documents

Function help {Echo "goto-nvimconfig - Go to Neovim Config Directory"; Echo "sprofile - Save Powershell Profile to Git Repo"; Echo "desk - Go to Desktop"; Echo "doc - Go to Documents"}
Set-Alias -Name phelp -Value help
